
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/
      :type-slots $ {} $ :dispatch-op 'app.types/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'CodeEntry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct CodeEntry ([] Code) (:doc String) (:code Code)
          :examples $ []
          :schema $ quote StructDef
        'CodeNode $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion CodeNode app.comp.container/Expr app.comp.container/Leaf
          :examples $ []
          :schema $ quote UnionDef
        'Expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Expr
            :data $ Map Dynamic app.comp.container/CodeNode
            :by Dynamic
            :at Dynamic
          :examples $ []
          :schema $ quote StructDef
        'FileEntry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct FileEntry ([] Namespace Definitions) (:ns Namespace) (:defs Definitions)
          :examples $ []
          :schema $ quote StructDef
        'Leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Leaf (:by Dynamic) (:at Dynamic) (:text Dynamic)
          :examples $ []
          :schema $ quote StructDef
        'as-map $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn as-map (data)
            if (map? data)
              decode-map-as data $ Map Dynamic Dynamic
              raise |Expected_map
          :examples $ []
          :schema $ quote $ Fn Input
            -> $ Map Dynamic Dynamic
            :generics Input
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel on-control)
            let
                store $ :store reel
                states $ :states store
                cursor $ match (get states :cursor)
                  (:some value)
                    decode-map-as value $ List respo.schema/CoordKey
                  (:none) ([])
                state $ match (get states :data)
                  (:some value)
                    if (struct? value)
                      struct-match value (types/State checked checked)
                        _ other $ raise "|Expected a State struct"
                      raise "|Expected a State struct"
                  (:none) (types/State :content | :next-data nil)
                display-text $ format-cirru-edn $ :next-data state
              div
                {} $ :class-name $ str-spaced css/fullscreen css/global css/row
                textarea $ {}
                  :value $ :content state
                  :placeholder |Content
                  :class-name $ str-spaced css/expand css/textarea css/font-code!
                  :style $ {} (:white-space :pre) (:font-size 12)
                  :on-input $ fn (e d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn app.types/Op $ -> Unit
                      -> Unit
                    d! $ app.types/Op :states cursor $ assoc state :content
                      decode-map-as (:value e) 'String
                  :on $ {} $ :paste
                    fn (e d!)
                      d! $ app.types/Op :states cursor $ assoc state :next-data nil
                      d! $ app.types/Op :interact
                space-x 2
                div
                  {} $ :class-name $ str-spaced css/column css/expand
                  div ({})
                    button $ {} (:class-name css/button) (:inner-text |Convert_Calcit)
                      :on-click $ fn (e d!)
                        d! $ app.types/Op :states cursor $ assoc state :next-data
                          transform-snapshot $ parse-cirru-edn $ :content state
                        d! $ app.types/Op :interact
                    space-x 8
                    button $ {} (:class-name css/button) (:inner-text |Convert_Compact)
                      :on-click $ fn (e d!)
                        d! $ app.types/Op :states cursor $ assoc state :next-data
                          transform-compact $ parse-cirru-edn $ :content state
                        d! $ app.types/Op :interact
                    space-x 8
                    button $ {} (:class-name css/button) (:inner-text |FileEntry)
                      :on-click $ fn (e d!)
                        d! $ app.types/Op :states cursor $ assoc state :next-data
                          transform-file-entry $ parse-cirru-edn $ :content state
                        d! $ app.types/Op :interact
                  textarea $ {} (:value display-text)
                    :class-name $ str-spaced css/expand css/textarea css/font-code!
                    :placeholder |data
                    :style $ {} (:white-space :pre) (:font-size 12)
                    :disabled true
                  comp-copy $ if
                    and (:interacted? store)
                      non-nil? $ :next-data state
                    Some display-text
                    , None
                if dev?
                  Some $ comp-typed-reel (>> states :reel) reel ({}) on-control
                  , None
          :examples $ []
          :schema $ quote $ Fn (reel.typed/State types/Op types/Store)
            Fn reel.typed/Control $ -> Unit
            -> respo.schema/Component
        'comp-copy $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-copy (text)
            [] (effect-copy text)
              span $ {}
          :examples $ []
          :schema $ quote $ Fn (Option String) (-> respo.schema/Component)
        'effect-copy $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defeffect effect-copy (raw-content) (action el at?)
            let
                content $ decode-map-as raw-content $ Option String
              println "|Copy Effect:" action $ .some? content
              when (= action :update)
                match content
                  (:some text)
                    do (copy! text)
                      println |Copied! $ .len text
                  (:none) &unit
              , &unit
          :examples $ []
          :schema $ quote $ Fn (Option String) (-> respo.schema/Effect) (:features :js-ffi)
        'map-field $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn map-field (source key)
            match (get source key)
              (:some value) (as-map value)
              (:none) (raise |Expected_map)
          :examples $ []
          :schema $ quote $ Fn (Map Dynamic Dynamic) Tag
            -> $ Map Dynamic Dynamic
        'transform-code $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-code (expr)
            let
                source $ &merge
                  {} (:by nil) (:at nil) (:text nil)
                  as-map expr
                expr? $ match (get source :type)
                  (:some kind)
                    and (tag? kind)
                      = (decode-map-as kind 'Tag) :expr
                  (:none) false
              if expr?
                Expr :by
                  .unwrap $ get source :by
                  , :at
                    .unwrap $ get source :at
                    , :data $ filter-map-kv (map-field source :data)
                      fn (k v)
                        hint-fn $ Fn Dynamic Dynamic $ -> (MapEntryDecision Dynamic app.comp.container/CodeNode)
                        MapEntryDecision :keep k $ transform-code v
                Leaf :by
                  .unwrap $ get source :by
                  , :at
                    .unwrap $ get source :at
                    , :text $ .unwrap $ get source :text
          :examples $ []
          :schema $ quote $ Fn Input (-> CodeNode) (:generics Input)
        'transform-compact $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-compact (data)
            let
                root $ as-map data
                files $ map-field root :files
              assoc root :files $ filter-map-kv files $ fn (k file)
                hint-fn $ Fn Dynamic Dynamic $ ->
                  MapEntryDecision Dynamic $ Map Dynamic Dynamic
                let
                    file-map $ &merge
                      {} $ :ns nil
                      as-map file
                    defs $ map-field file-map :defs
                    next-defs $ filter-map-kv defs $ fn (def-name code)
                      hint-fn $ Fn Dynamic Dynamic $ ->
                        MapEntryDecision Dynamic $ CodeEntry Dynamic
                      MapEntryDecision :keep def-name $ CodeEntry :doc | :code code
                  MapEntryDecision :keep k $ assoc
                    assoc file-map :ns $ CodeEntry :doc | :code $ .unwrap (get file-map :ns)
                    , :defs next-defs
          :examples $ []
          :schema $ quote $ Fn Input
            -> $ Map Dynamic Dynamic
            :generics Input
        'transform-file-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-file-entry (snapshot)
            let
                root $ as-map snapshot
                files $ map-field root :files
              assoc root :files $ filter-map-kv files $ fn (k file)
                hint-fn $ Fn Dynamic Dynamic $ ->
                  MapEntryDecision Dynamic $ FileEntry Dynamic Dynamic
                let
                    file-map $ &merge
                      {} (:ns nil) (:defs nil)
                      as-map file
                  MapEntryDecision :keep k $ FileEntry :ns
                    .unwrap $ get file-map :ns
                    , :defs $ .unwrap (get file-map :defs)
          :examples $ []
          :schema $ quote $ Fn Input
            -> $ Map Dynamic Dynamic
            :generics Input
        'transform-snapshot $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-snapshot (snapshot)
            let
                root $ as-map snapshot
                ir $ &merge
                  {} $ :package nil
                  map-field root :ir
                files $ map-field ir :files
                next-files $ filter-map-kv files $ fn (k file)
                  hint-fn $ Fn Dynamic Dynamic $ ->
                    MapEntryDecision Dynamic $ FileEntry (CodeEntry CodeNode)
                      Map Dynamic $ CodeEntry CodeNode
                  let
                      file-map $ as-map file
                      defs $ map-field file-map :defs
                      next-defs $ filter-map-kv defs $ fn (def-name code)
                        hint-fn $ Fn Dynamic Dynamic $ ->
                          MapEntryDecision Dynamic $ CodeEntry CodeNode
                        MapEntryDecision :keep def-name $ CodeEntry :doc | :code $ transform-code code
                    MapEntryDecision :keep k $ FileEntry :ns
                      CodeEntry :doc | :code $ transform-code $ map-field file-map :ns
                      , :defs next-defs
              assoc
                assoc (dissoc root :ir) :package $ .unwrap $ get ir :package
                , :files next-files
          :examples $ []
          :schema $ quote $ Fn Input
            -> $ Map Dynamic Dynamic
            :generics Input
          :tests $ [] $ %{} 'TestEntry (:name |preserves-three-legacy-formats)
            :code $ quote $ do
              let
                  leaf $ {} (:type :leaf) (:text |name)
                  expected-leaf $ Leaf :by nil :at nil :text |name
                  expr $ {} (:type :expr)
                    :data $ {} $ 0 leaf
                  expected-expr $ Expr :by nil :at nil :data $ {} (0 expected-leaf)
                  input $ {} (:extra |keep)
                    :ir $ {} (:package |demo)
                      :files $ {} $ |demo.main
                        {} (:ns expr)
                          :defs $ {} $ |main leaf
                  expected $ {} (:extra |keep) (:package |demo)
                    :files $ {} $ |demo.main
                      FileEntry :ns (CodeEntry :doc | :code expected-expr) :defs $ {} $ |main (CodeEntry :doc | :code expected-leaf)
                assert= (format-cirru-edn expected)
                  format-cirru-edn $ transform-snapshot input
              let
                  input $ {} $ :files
                    {} $ |demo.main $ {} (:ns |namespace-data)
                      :defs $ {}
                  expected $ {} $ :files
                    {} $ |demo.main $ FileEntry :ns |namespace-data :defs ({})
                assert= (format-cirru-edn expected)
                  format-cirru-edn $ transform-file-entry input
              let
                  input $ {} $ :files
                    {} $ |demo.main $ {} (:ns |namespace-data) (:extra |keep)
                      :defs $ {} $ |main |definition-data
                  expected $ {} $ :files
                    {} $ |demo.main $ {} (:extra |keep)
                      :ns $ CodeEntry :doc | :code |namespace-data
                      :defs $ {} $ |main (CodeEntry :doc | :code |definition-data)
                assert= (format-cirru-edn expected)
                  format-cirru-edn $ transform-compact input
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input
            respo.comp.space :refer $ space-x
            reel.comp.reel :refer $ comp-typed-reel
            app.config :refer $ dev?
            respo-ui.css :as css
            |copy-text-to-clipboard :default copy!
            reel.schema :as reel-schema
            app.types :as types
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ quote Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site (app.types/SiteConfig :storage-key |workflow)
          :examples $ []
          :schema $ quote app.types/SiteConfig
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel (typed/new-reel schema/store)
          :examples $ []
          :schema $ quote $ Ref (typed/State app.types/Op app.types/Store)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ js/console.log |Dispatch: op
            reset! *reel $ match op
              (reel.typed/Control control) (typed/apply-control updater @*reel control)
              (app.types/Op action)
                typed/record-op updater @*reel action (generate-id!)
                  :timestamp $ shared/date-now-snapshot
            , &unit
          :examples $ []
          :schema $ quote $ Fn app.types/ResolvedOp (-> Unit) (:features :js-ffi)
        'dispatch-event! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch-event! (op) (dispatch! op)
          :examples $ []
          :schema $ quote $ Fn app.types/Op (-> Unit)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println |Running_mode: $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            match
              browser/storage-get $ :storage-key config/site
              (:some raw)
                match
                  app.types/decode-store $ parse-cirru-edn raw
                  (:some stored)
                    dispatch! $ app.types/Op :hydrate-storage stored
                  (:none)
                    do (hud! |error |Invalid_saved_state) (raise |Invalid_saved_state)
              (:none) &unit
            render-app!
            add-watch! *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k on-control!
            browser/set-before-unload! $ fn (event) (persist-storage!)
            browser/set-interval! persist-storage! 60000
            println |App_started.
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            narrow-element $ .unwrap $ browser/query-selector |.app
          :examples $ []
          :schema $ quote respo.dom/DomElement
        'on-control! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-control! (control) (dispatch! control)
          :examples $ []
          :schema $ quote $ Fn typed/Control (-> Unit)
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            browser/storage-set! (:storage-key config/site)
              format-cirru-edn $ :store @*reel
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch! *reel :changes) (clear-cache!)
                add-watch! *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ typed/refresh updater @*reel schema/store
                hud! |ok~ |Ok
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*reel on-control!
              , dispatch-event!
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            reel.typed :as typed
            js-ffi.browser :as browser
            js-ffi.shared :as shared
            respo.ffi.browser :refer $ narrow-element
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'store
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            app.types/Store :states ({}) :interacted? false
          :examples $ []
          :schema $ quote Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
          :require $ app.types :refer $ Store
    'app.types $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (List respo.schema/CoordKey) app.types/State
            :hydrate-storage app.types/Store
            :interact
          :examples $ []
          :schema $ quote EnumDef
        'ResolvedOp $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion ResolvedOp app.types/Op reel.typed/Control
          :examples $ []
          :schema $ quote UnionDef
        'SiteConfig $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct SiteConfig (:storage-key String)
          :examples $ []
          :schema $ quote StructDef
        'State $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct State (:content String) (:next-data Dynamic)
          :examples $ []
          :schema $ quote StructDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ Map Dynamic Dynamic
            :interacted? Bool
          :examples $ []
          :schema $ quote StructDef
        'decode-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-state (value)
            if (struct? value)
              match
                try-decode-map-as (&struct:to-map value) State
                (:ok checked) (Some checked)
                (:err _) None
              , None
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ Option State
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (data)
            if
              or (map? data) (struct? data)
              match (get data :states)
                (:some states)
                  if (map? states)
                    let
                        cursor-valid? $ match (get states :cursor)
                          (:some cursor)
                            match
                              try-decode-map-as cursor $ List respo.schema/CoordKey
                              (:ok _) true
                              (:err _) false
                          (:none) true
                        next-states $ match (get states :data)
                          (:some state)
                            match (decode-state state)
                              (:some checked)
                                Some $ assoc states :data checked
                              (:none) None
                          (:none) (Some states)
                      if cursor-valid?
                        match next-states
                          (:some checked-states)
                            Some $ Store :states
                              decode-map-as checked-states $ Map Dynamic Dynamic
                              , :interacted? false
                          (:none) None
                        , None
                    , None
                (:none) None
              , None
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ Option Store
          :tests $ [] $ %{} 'TestEntry (:name |serialized-state-roundtrip)
            :code $ quote $ let
                raw $ parse-cirru-edn $ format-cirru-edn
                  {} $ :states $ {}
                    :cursor $ []
                    :data $ State :content "|0321合成🐈" :next-data nil
                    :extra |keep
              match (decode-store raw)
                (:some restored)
                  do
                    assert= (State :content "|0321合成🐈" :next-data nil)
                      .unwrap $ get (:states restored) :data
                    assert= ([])
                      .unwrap $ get (:states restored) :cursor
                    assert= |keep $ .unwrap $ get (:states restored) :extra
                (:none) (raise |Serialized-State-must-restore)
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.types
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor s)
                assoc store :states $ decode-map-as
                  update-state-tree (:states store) cursor s
                  Map Dynamic Dynamic
              (:hydrate-storage data) data
              (:interact) (assoc store :interacted? true)
          :examples $ []
          :schema $ quote $ Fn app.types/Store app.types/Op String Number (-> app.types/Store)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-state-tree
