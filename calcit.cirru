
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :native)
      :reload-fn 'app.main/reload!
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
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ unsafe-coerce
                  unsafe-coerce
                    reel.schema/read-field reel :store
                    , 'app.types/Store
                  , 'app.types/Store
                states $ :states store
                cursor $ or (&map:get states :cursor) ([])
                state $ unsafe-coerce
                  or (&map:get states :data)
                    %{} app.types/State (:content |) (:next-data nil)
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
                    d! cursor $ assoc state :content $ &map:get e :value
                  :on $ {} $ :paste
                    fn (e d!)
                      d! cursor $ assoc state :next-data nil
                      d! $ :: :interact
                =< 2 nil
                div
                  {} $ :class-name $ str-spaced css/column css/expand
                  div ({})
                    button $ {} (:class-name css/button) (:inner-text "|Convert Calcit")
                      :on-click $ fn (e d!)
                        d! cursor $ assoc state :next-data $ transform-snapshot
                          parse-cirru-edn $ :content state
                        d! $ :: :interact
                    =< 8 nil
                    button $ {} (:class-name css/button) (:inner-text "|Convert Compact")
                      :on-click $ fn (e d!)
                        d! cursor $ assoc state :next-data $ transform-compact
                          parse-cirru-edn $ :content state
                        d! $ :: :interact
                    =< 8 nil
                    button $ {} (:class-name css/button) (:inner-text |FileEntry)
                      :on-click $ fn (e d!)
                        d! cursor $ assoc state :next-data $ transform-file-entry
                          parse-cirru-edn $ :content state
                        d! $ :: :interact
                  textarea $ {} (:value display-text)
                    :class-name $ str-spaced css/expand css/textarea css/font-code!
                    :placeholder |data
                    :style $ {} (:white-space :pre) (:font-size 12)
                    :disabled true
                  if (:interacted? store)
                    comp-copy $ :next-data state
                when dev? $ comp-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-copy $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-copy (data)
            [] (effect-copy data)
              span $ {}
          :examples $ []
          :schema $ :: 'Dynamic
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
          :schema $ :: 'Dynamic
        'transform-code $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-code (expr)
            if
              = :expr $ &map:get expr :type
              %{} Expr
                :by $ &map:get expr :by
                :at $ &map:get expr :at
                :data $ -> (&map:get expr :data)
                  map-kv $ fn (k v)
                    [] k $ transform-code v
              %{} Leaf
                :by $ &map:get expr :by
                :at $ &map:get expr :at
                :text $ &map:get expr :text
          :examples $ []
          :schema $ :: 'Dynamic
        'transform-compact $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-compact (data)
            -> data $ update :files $ fn (files)
              -> files $ map-kv $ fn (k file)
                [] k $ -> file
                  update :ns $ fn (c)
                    %{} CodeEntry (:doc |) (:code c)
                  update :defs $ fn (defs)
                    -> defs $ map-kv $ fn (def-name code)
                      [] def-name $ %{} CodeEntry (:doc |) (:code code)
          :examples $ []
          :schema $ :: 'Dynamic
        'transform-file-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-file-entry (snapshot)
            update snapshot :files $ fn (files)
              map-kv files $ fn (k v)
                [] k $ %{} FileEntry
                  :ns $ &map:get v :ns
                  :defs $ &map:get v :defs
          :examples $ []
          :schema $ :: 'Dynamic
        'transform-snapshot $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn transform-snapshot (snapshot)
            let
                next $ -> snapshot $ update-in ([] :ir :files)
                  fn (files)
                    ->
                      option:unwrap-or files $ {}
                      map-kv $ fn (k file)
                        [] k $ %{} FileEntry
                          :ns $ %{} CodeEntry (:doc |)
                            :code $ transform-code $ &map:get file :ns
                          :defs $ -> (&map:get file :defs)
                            map-kv $ fn (def-name code)
                              [] def-name $ %{} CodeEntry (:doc |)
                                :code $ transform-code code
              -> next (dissoc :ir)
                assoc :package $ option:unwrap-or
                  get-in next $ [] :ir :package
                  , nil
                assoc :files $ option:unwrap-or
                  get-in next $ [] :ir :files
                  {}
          :examples $ []
          :schema $ :: 'Dynamic
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
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ option:unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Dynamic
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            %{} app.types/SiteConfig $ :storage-key |workflow
          :examples $ []
          :schema $ :: 'app.types/SiteConfig
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *reel
            -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
          :schema $ :: 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when
              and config/dev? $ not=
                option:unwrap-or (nth op 0) :unknown
                , :states
              js/console.log |Dispatch: op
            reset! *reel $ reel-updater updater @*reel op
          :examples $ []
          :schema $ :: 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
            flipped js/setInterval 60000 persist-storage!
            let
                raw $ js/localStorage.getItem $ :storage-key config/site
              when (js-present? raw)
                dispatch! $ :: :hydrate-storage $ assoc
                  parse-cirru-edn $ unsafe-coerce raw String
                  , :interacted? false
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            js/document.querySelector |.app
          :examples $ []
          :schema $ :: 'Dynamic
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! () (js/console.log |persist)
            js/localStorage.setItem (:storage-key config/site)
              format-cirru-edn $ reel.schema/read-field @*reel :store
          :examples $ []
          :schema $ :: 'Dynamic
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Dynamic
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Dynamic
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
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'store
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            %{} app.types/Store
              :states $ {}
              :interacted? false
          :examples $ []
          :schema $ :: 'app.types/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
          :require $ app.types :refer $ Store
    'app.types $ %{} 'FileEntry
      :defs $ {}
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
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.types
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor s) (update-states store cursor s)
              (:hydrate-storage data) data
              (:interact) (assoc store :interacted? true)
              _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-states
