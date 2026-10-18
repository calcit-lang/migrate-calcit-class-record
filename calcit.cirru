
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'CodeEntry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct CodeEntry (:doc 'String) (:code 'Dynamic)
          :examples $ []
          :schema $ :: 'StructDef
        'Expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Expr
            :data $ :: 'Map 'Dynamic 'Dynamic
            :by 'Dynamic
            :at 'Dynamic
          :examples $ []
          :schema $ :: 'StructDef
        'FileEntry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct FileEntry (:ns 'Dynamic) (:defs 'Dynamic)
          :examples $ []
          :schema $ :: 'StructDef
        'Leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Leaf (:by 'Dynamic) (:at 'Dynamic) (:text 'Dynamic)
          :examples $ []
          :schema $ :: 'StructDef
        'as-map $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn as-map (data)
            if (map? data)
              decode-map-as data $ :: 'Map 'Dynamic 'Dynamic
              raise |Expected_map
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'Map 'Dynamic 'Dynamic
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                cursor $ match (get states :cursor)
                  (:some value)
                    decode-map-as value $ :: 'List 'Dynamic
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
                    d! $ types/app-event $ app.types/Op :states cursor
                      assoc state :content $ decode-map-as
                        .unwrap-or (get e :value) nil
                        , 'String
                  :on $ {} $ :paste
                    fn (e d!)
                      d! $ types/app-event $ app.types/Op :states cursor (assoc state :next-data nil)
                      d! $ types/app-event $ app.types/Op :interact
                =< 2 0
                div
                  {} $ :class-name $ str-spaced css/column css/expand
                  div ({})
                    button $ {} (:class-name css/button) (:inner-text |Convert_Calcit)
                      :on-click $ fn (e d!)
                        d! $ types/app-event $ app.types/Op :states cursor
                          assoc state :next-data $ transform-snapshot $ parse-cirru-edn (:content state)
                        d! $ types/app-event $ app.types/Op :interact
                    =< 8 0
                    button $ {} (:class-name css/button) (:inner-text |Convert_Compact)
                      :on-click $ fn (e d!)
                        d! $ types/app-event $ app.types/Op :states cursor
                          assoc state :next-data $ transform-compact $ parse-cirru-edn (:content state)
                        d! $ types/app-event $ app.types/Op :interact
                    =< 8 0
                    button $ {} (:class-name css/button) (:inner-text |FileEntry)
                      :on-click $ fn (e d!)
                        d! $ types/app-event $ app.types/Op :states cursor
                          assoc state :next-data $ transform-file-entry $ parse-cirru-edn (:content state)
                        d! $ types/app-event $ app.types/Op :interact
                  textarea $ {} (:value display-text)
                    :class-name $ str-spaced css/expand css/textarea css/font-code!
                    :placeholder |data
                    :style $ {} (:white-space :pre) (:font-size 12)
                    :disabled true
                  if (:interacted? store)
                    comp-copy $ :next-data state
                    span $ {}
                when dev? $ comp-typed-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'app.types/Op 'app.types/Store
        'comp-copy $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-copy (data)
            [] (effect-copy data)
              span $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'Dynamic
        'effect-copy $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defeffect effect-copy (data) (action el at?)
            println "|Copy Effect:" action $ non-nil? data
            if (= action :update)
              if (non-nil? data)
                let
                    text $ format-cirru-edn data
                  copy! text
                  println |Copied! $ count text
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Effect)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'transform-code $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-code (expr)
            let
                source $ as-map expr
                node-type $ .unwrap-or (get source :type) nil
              if
                and (tag? node-type)
                  = (decode-map-as node-type 'Tag) :expr
                Expr :by
                  .unwrap-or (get source :by) nil
                  , :at
                    .unwrap-or (get source :at) nil
                    , :data $ filter-map-kv
                      as-map $ .unwrap-or (get source :data) nil
                      fn (k v)
                        hint-fn $ {}
                          :args $ [] 'Dynamic 'Dynamic
                          :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                        MapEntryDecision :keep k $ transform-code v
                Leaf :by
                  .unwrap-or (get source :by) nil
                  , :at
                    .unwrap-or (get source :at) nil
                    , :text $ .unwrap-or (get source :text) nil
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic
        'transform-compact $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-compact (data)
            let
                root $ as-map data
                files $ as-map $ .unwrap-or (get root :files) nil
              assoc root :files $ filter-map-kv files $ fn (k file)
                hint-fn $ {}
                  :args $ [] 'Dynamic 'Dynamic
                  :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                let
                    file-map $ as-map file
                    defs $ as-map $ .unwrap-or (get file-map :defs) nil
                    next-defs $ filter-map-kv defs $ fn (def-name code)
                      hint-fn $ {}
                        :args $ [] 'Dynamic 'Dynamic
                        :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                      MapEntryDecision :keep def-name $ CodeEntry :doc | :code code
                  MapEntryDecision :keep k $ assoc
                    assoc file-map :ns $ CodeEntry :doc | :code $ .unwrap-or (get file-map :ns) nil
                    , :defs next-defs
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'Map 'Dynamic 'Dynamic
        'transform-file-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-file-entry (snapshot)
            let
                root $ as-map snapshot
                files $ as-map $ .unwrap-or (get root :files) nil
              assoc root :files $ filter-map-kv files $ fn (k file)
                hint-fn $ {}
                  :args $ [] 'Dynamic 'Dynamic
                  :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                let
                    file-map $ as-map file
                  MapEntryDecision :keep k $ FileEntry :ns
                    .unwrap-or (get file-map :ns) nil
                    , :defs $ .unwrap-or (get file-map :defs) nil
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'Map 'Dynamic 'Dynamic
        'transform-snapshot $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-snapshot (snapshot)
            let
                root $ as-map snapshot
                ir $ as-map $ .unwrap-or (get root :ir) nil
                files $ as-map $ .unwrap-or (get ir :files) nil
                next-files $ filter-map-kv files $ fn (k file)
                  hint-fn $ {}
                    :args $ [] 'Dynamic 'Dynamic
                    :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                  let
                      file-map $ as-map file
                      defs $ as-map $ .unwrap-or (get file-map :defs) nil
                      next-defs $ filter-map-kv defs $ fn (def-name code)
                        hint-fn $ {}
                          :args $ [] 'Dynamic 'Dynamic
                          :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                        MapEntryDecision :keep def-name $ CodeEntry :doc | :code $ transform-code code
                    MapEntryDecision :keep k $ FileEntry :ns
                      CodeEntry :doc | :code $ transform-code $ .unwrap-or (get file-map :ns) nil
                      , :defs next-defs
              assoc
                assoc (dissoc root :ir) :package $ .unwrap-or (get ir :package) nil
                , :files next-files
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'Map 'Dynamic 'Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |preserves-three-legacy-formats)
            :code $ quote $ do
              let
                  leaf $ {} (:type :leaf) (:text |name)
                  expected-leaf $ Leaf :by nil :at nil :text |name
                  input $ {} (:extra |keep)
                    :ir $ {} (:package |demo)
                      :files $ {} $ |demo.main
                        {} (:ns leaf)
                          :defs $ {} $ |main leaf
                  expected $ {} (:extra |keep) (:package |demo)
                    :files $ {} $ |demo.main
                      FileEntry :ns (CodeEntry :doc | :code expected-leaf) :defs $ {} $ |main (CodeEntry :doc | :code expected-leaf)
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
            respo.comp.space :refer $ =<
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
            = |dev $ option:unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site (app.types/SiteConfig :storage-key |workflow)
          :examples $ []
          :schema $ :: 'app.types/SiteConfig
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel (typed/new-reel schema/store)
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'app.types/Op 'app.types/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (event)
            if (enum? event)
              do
                when config/dev? $ js/console.log |Dispatch: event
                match (typed/decode-control event)
                  (:some action)
                    reset! *reel $ typed/apply-control updater @*reel action
                  (:none)
                    reset! *reel $ typed/record-op updater @*reel (types/read-app-event event) (generate-id!)
                      :timestamp $ shared/date-now-snapshot
                , &unit
              raise "|Expected a UI event enum"
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println |Running_mode: $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch! *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            browser/set-before-unload! $ fn (event) (persist-storage!)
            browser/set-interval! persist-storage! 60000
            match
              browser/storage-get $ :storage-key config/site
              (:some raw)
                match
                  app.types/decode-store $ parse-cirru-edn raw
                  (:some stored)
                    dispatch! $ types/app-event $ app.types/Op :hydrate-storage stored
                  (:none) (hud! |error |Ignored_invalid_saved_state)
              (:none) &unit
            println |App_started.
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            narrow-element $ .unwrap $ browser/query-selector |.app
          :examples $ []
          :schema $ :: 'respo.dom/DomElement
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            browser/storage-set! (:storage-key config/site)
              format-cirru-edn $ :store @*reel
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
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
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools! generate-id!
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            reel.typed :as typed
            js-ffi.browser :as browser
            js-ffi.shared :as shared
            app.types :as types
            respo.ffi.browser :refer $ narrow-element
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'store
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            app.types/Store :states ({}) :interacted? false
          :examples $ []
          :schema $ :: 'app.types/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
          :require $ app.types :refer $ Store
    'app.types $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (:: 'List 'Dynamic) 'Dynamic
            :hydrate-storage 'app.types/Store
            :interact
          :examples $ []
          :schema $ :: 'EnumDef
        'OpEnvelope $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct OpEnvelope (:op 'app.types/Op)
          :examples $ []
          :schema $ :: 'StructDef
        'SiteConfig $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct SiteConfig (:storage-key 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'State $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct State (:content 'String) (:next-data 'Dynamic)
          :examples $ []
          :schema $ :: 'StructDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Dynamic 'Dynamic
            :interacted? 'Bool
          :examples $ []
          :schema $ :: 'StructDef
        'app-event $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn app-event (op)
            :: :app/event $ OpEnvelope :op op
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Enum)
            :args $ [] 'app.types/Op
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (data)
            if
              or (map? data) (struct? data)
              match (get data :states)
                (:some states)
                  if (map? states)
                    let
                        cursor-valid? $ match (get states :cursor)
                          (:some cursor) (list? cursor)
                          (:none) true
                        data-valid? $ match (get states :data)
                          (:some state)
                            if (struct? state)
                              struct-match state (State typed-state true) (_ _ false)
                              , false
                          (:none) true
                      if (and cursor-valid? data-valid?)
                        Option :some $ Store :states
                          decode-map-as states $ :: 'Map 'Dynamic 'Dynamic
                          , :interacted? false
                        Option :none
                    Option :none
                (:none) (Option :none)
              Option :none
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'Option 'app.types/Store
        'read-app-event $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-app-event (event)
            match event
              (:app/event envelope)
                if (struct? envelope)
                  struct-match envelope
                    OpEnvelope checked $ :op checked
                    _ other $ raise "|Expected an app OpEnvelope"
                  raise "|Expected an app OpEnvelope"
              _ $ raise "|Unknown UI event; reload after upgrading the application"
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.types/Op)
            :args $ [] 'Enum
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
                  :: 'Map 'Dynamic 'Dynamic
              (:hydrate-storage data) data
              (:interact) (assoc store :interacted? true)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.types/Store)
            :args $ [] 'app.types/Store 'app.types/Op 'String 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-state-tree
