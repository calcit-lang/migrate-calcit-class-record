
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'CodeEntry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct CodeEntry (:doc 'Dynamic) (:code 'Dynamic)
          :examples $ []
          :schema $ :: 'StructDef
        'Expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Expr (:data 'Dynamic) (:by 'Dynamic) (:at 'Dynamic)
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
              assert-type data $ :: 'Map 'Dynamic 'Dynamic
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
                  (:some value) (assert-type value 'List)
                  (:none) ([])
                state $ assert-type
                  match (get states :data)
                    (:some value) value
                    (:none) (app.types/State :content | :next-data nil)
                  , 'app.types/State
                display-text $ format-cirru-edn $ :next-data state
              div
                {} $ :class-name $ str-spaced css/fullscreen css/global css/row
                textarea $ {}
                  :value $ :content state
                  :placeholder |Content
                  :class-name $ str-spaced css/expand css/textarea css/font-code!
                  :style $ {} (:white-space :pre) (:font-size 12)
                  :on-input $ fn (e d!)
                    d! $ app.types/Op :states cursor $ assoc state :content
                      assert-type (&map:get e :value) 'String
                  :on $ {} $ :paste
                    fn (e d!)
                      d! $ app.types/Op :states cursor $ assoc state :next-data nil
                      d! $ app.types/Op :interact
                =< 2 0
                div
                  {} $ :class-name $ str-spaced css/column css/expand
                  div ({})
                    button $ {} (:class-name css/button) (:inner-text |Convert_Calcit)
                      :on-click $ fn (e d!)
                        d! $ app.types/Op :states cursor $ assoc state :next-data
                          transform-snapshot $ parse-cirru-edn $ :content state
                        d! $ app.types/Op :interact
                    =< 8 0
                    button $ {} (:class-name css/button) (:inner-text |Convert_Compact)
                      :on-click $ fn (e d!)
                        d! $ app.types/Op :states cursor $ assoc state :next-data
                          transform-compact $ parse-cirru-edn $ :content state
                        d! $ app.types/Op :interact
                    =< 8 0
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
                  if (:interacted? store)
                    comp-copy $ :next-data state
                    span $ {}
                when dev? $ comp-reel (>> states :reel) reel $ {}
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
            println "|Copy Effect:" action $ some? data
            if (= action :update)
              if (some? data)
                let
                    text $ format-cirru-edn data
                  copy! text
                  println |Copied! $ count text
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Effect)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'transform-code $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-code (expr)
            let
                source $ as-map expr
                node-type $ &map:get source :type
              if
                and (tag? node-type)
                  = (assert-type node-type 'Tag) :expr
                Expr :by (&map:get source :by) :at (&map:get source :at) :data $ filter-map-kv
                  as-map $ &map:get source :data
                  fn (k v)
                    hint-fn $ {}
                      :args $ [] 'Dynamic 'Dynamic
                      :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                    %:: MapEntryDecision :keep k $ transform-code v
                Leaf :by (&map:get source :by) :at (&map:get source :at) :text $ &map:get source :text
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic
        'transform-compact $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-compact (data)
            let
                root $ as-map data
                files $ as-map $ &map:get root :files
              assoc root :files $ filter-map-kv files $ fn (k file)
                hint-fn $ {}
                  :args $ [] 'Dynamic 'Dynamic
                  :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                let
                    file-map $ as-map file
                    defs $ as-map $ &map:get file-map :defs
                    next-defs $ filter-map-kv defs $ fn (def-name code)
                      hint-fn $ {}
                        :args $ [] 'Dynamic 'Dynamic
                        :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                      %:: MapEntryDecision :keep def-name $ %{} CodeEntry (:doc |) (:code code)
                  %:: MapEntryDecision :keep k $ assoc
                    assoc file-map :ns $ %{} CodeEntry (:doc |)
                      :code $ &map:get file-map :ns
                    , :defs next-defs
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic
        'transform-file-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-file-entry (snapshot)
            let
                root $ as-map snapshot
                files $ as-map $ &map:get root :files
              assoc root :files $ filter-map-kv files $ fn (k file)
                hint-fn $ {}
                  :args $ [] 'Dynamic 'Dynamic
                  :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                let
                    file-map $ as-map file
                  %:: MapEntryDecision :keep k $ FileEntry :ns (&map:get file-map :ns) :defs $ &map:get file-map :defs
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic
        'transform-snapshot $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-snapshot (snapshot)
            let
                root $ as-map snapshot
                ir $ as-map $ &map:get root :ir
                files $ as-map $ &map:get ir :files
                next-files $ filter-map-kv files $ fn (k file)
                  hint-fn $ {}
                    :args $ [] 'Dynamic 'Dynamic
                    :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                  let
                      file-map $ as-map file
                      defs $ as-map $ &map:get file-map :defs
                      next-defs $ filter-map-kv defs $ fn (def-name code)
                        hint-fn $ {}
                          :args $ [] 'Dynamic 'Dynamic
                          :return $ :: 'MapEntryDecision 'Dynamic 'Dynamic
                        %:: MapEntryDecision :keep def-name $ %{} CodeEntry (:doc |)
                          :code $ transform-code code
                    %:: MapEntryDecision :keep k $ FileEntry :ns
                      %{} CodeEntry (:doc |)
                        :code $ transform-code $ &map:get file-map :ns
                      , :defs next-defs
              assoc
                assoc (dissoc root :ir) :package $ &map:get ir :package
                , :files next-files
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
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
          :code $ quote $ defatom *reel (typed/new-reel schema/store)
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'app.types/Op 'app.types/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ js/console.log |Dispatch: op
            let
                typed-op $ assert-type op 'Enum
                control $ typed/decode-control typed-op
              reset! *reel $ assert-type
                match control
                  (:some action) (typed/apply-control updater @*reel action)
                  (:none)
                    typed/record-op updater @*reel (assert-type typed-op 'app.types/Op) (generate-id!)
                      :timestamp $ shared/date-now-snapshot
                :: 'reel.typed/State 'app.types/Op 'app.types/Store
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println |Running_mode: $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            browser/set-before-unload! $ fn (event) (persist-storage!)
            browser/set-interval! persist-storage! 60000
            match
              browser/storage-get $ :storage-key config/site
              (:some raw)
                match
                  app.types/decode-store $ parse-cirru-edn raw
                  (:some stored)
                    dispatch! $ app.types/Op :hydrate-storage stored
                  (:none) (hud! |error |Ignored_invalid_saved_state)
              (:none) &unit
            println |App_started.
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            option:unwrap $ browser/query-selector |.app
          :examples $ []
          :schema $ :: 'js-ffi.browser/DomElementHost
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
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ typed/refresh updater @*reel schema/store
                hud! |ok~ |Ok
              hud! |error build-errors
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
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            reel.typed :as typed
            js-ffi.browser :as browser
            js-ffi.shared :as shared
            app.types :as types
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
          :code $ quote $ defenum Op (:states 'List 'Dynamic) (:hydrate-storage 'app.types/Store) (:interact)
          :examples $ []
          :schema $ :: 'EnumDef
        'SiteConfig $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct SiteConfig (:storage-key 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'State $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct State (:content 'String) (:next-data 'Dynamic)
          :examples $ []
          :schema $ :: 'StructDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:states 'Map) (:interacted? 'Bool)
          :examples $ []
          :schema $ :: 'StructDef
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (data)
            if
              or (map? data) (struct? data)
              match (get data :states)
                (:some states)
                  if (map? states)
                    %some $ Store :states (assert-type states 'Map) :interacted? false
                    %none
                (:none) (%none)
              %none
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
            :return $ :: 'calcit.core/Option 'app.types/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.types
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor s)
                assoc store :states $ assert-type
                  update-state-tree (:states store) cursor s
                  , 'Map
              (:hydrate-storage data) data
              (:interact) (assoc store :interacted? true)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.types/Store)
            :args $ [] 'app.types/Store 'app.types/Op 'String 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ [] update-state-tree
