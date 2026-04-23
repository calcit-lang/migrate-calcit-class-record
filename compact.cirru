
{} (:about "|file is generated - never edit directly; learn cr edit/tree workflows before changing") (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |CodeEntry $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defstruct CodeEntry (:doc :dynamic) (:code :dynamic)
          :examples $ []
        |Expr $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defstruct Expr (:data :dynamic) (:by :dynamic) (:at :dynamic)
          :examples $ []
        |FileEntry $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defstruct FileEntry (:ns :dynamic) (:defs :dynamic)
          :examples $ []
        |Leaf $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defstruct Leaf (:by :dynamic) (:at :dynamic) (:text :dynamic)
          :examples $ []
        |comp-container $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $ :store reel
                  states $ :states store
                  cursor $ or (:cursor states) ([])
                  state $ or (:data states)
                    {} (:content |) (:next-data nil)
                  display-text $ format-cirru-edn (:next-data state)
                div
                  {} $ :class-name (str-spaced css/fullscreen css/global css/row)
                  textarea $ {}
                    :value $ :content state
                    :placeholder |Content
                    :class-name $ str-spaced css/expand css/textarea css/font-code!
                    :style $ {} (:white-space :pre) (:font-size 12)
                    :on-input $ fn (e d!)
                      d! cursor $ assoc state :content (:value e)
                    :on-paste $ fn (e d!)
                      d! cursor $ assoc state :next-data nil
                      d! $ :: :interact
                  =< 2 nil
                  div
                    {} $ :class-name (str-spaced css/column css/expand)
                    div ({})
                      button $ {} (:class-name css/button) (:inner-text "|Convert Calcit")
                        :on-click $ fn (e d!)
                          d! cursor $ assoc state :next-data
                            transform-snapshot $ parse-cirru-edn (:content state)
                          d! $ :: :interact
                      =< 8 nil
                      button $ {} (:class-name css/button) (:inner-text "|Convert Compact")
                        :on-click $ fn (e d!)
                          d! cursor $ assoc state :next-data
                            transform-compact $ parse-cirru-edn (:content state)
                          d! $ :: :interact
                      =< 8 nil
                      button $ {} (:class-name css/button) (:inner-text |FileEntry)
                        :on-click $ fn (e d!)
                          d! cursor $ assoc state :next-data
                            transform-file-entry $ parse-cirru-edn (:content state)
                          d! $ :: :interact
                    textarea $ {} (:value display-text)
                      :class-name $ str-spaced css/expand css/textarea css/font-code!
                      :placeholder |data
                      :style $ {} (:white-space :pre) (:font-size 12)
                      :disabled true
                    if (:interacted? store)
                      comp-copy $ :next-data state
                  when dev? $ comp-reel (>> states :reel) reel ({})
          :examples $ []
        |comp-copy $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defcomp comp-copy (data)
              [] (effect-copy data)
                span $ {}
          :examples $ []
        |effect-copy $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defeffect effect-copy (data) (action el at?)
              println "|Copy Effect:" action $ some? data
              if (= action :update)
                if (some? data)
                  let
                      text $ format-cirru-edn data
                    copy! text
                    println |Copied! $ count text
          :examples $ []
        |transform-code $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn transform-code (expr)
              if
                = :expr $ :type expr
                %{} Expr
                  :by $ :by expr
                  :at $ :at expr
                  :data $ -> (:data expr)
                    map-kv $ fn (k v)
                      [] k $ transform-code v
                %{} Leaf
                  :by $ :by expr
                  :at $ :at expr
                  :text $ :text expr
          :examples $ []
        |transform-compact $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn transform-compact (data)
              -> data $ update :files
                fn (files)
                  -> files $ map-kv
                    fn (k file)
                      [] k $ -> file
                        update :ns $ fn (c)
                          %{} CodeEntry (:doc |) (:code c)
                        update :defs $ fn (defs)
                          -> defs $ map-kv
                            fn (def-name code)
                              [] def-name $ %{} CodeEntry (:doc |) (:code code)
          :examples $ []
        |transform-file-entry $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn transform-file-entry (snapshot)
              update snapshot :files $ fn (files)
                map-kv files $ fn (k v)
                  [] k $ %{} FileEntry
                    :ns $ :ns v
                    :defs $ :defs v
          :examples $ []
        |transform-snapshot $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn transform-snapshot (snapshot)
              let
                  next $ -> snapshot
                    update-in ([] :ir :files)
                      fn (files)
                        -> files $ map-kv
                          fn (k file)
                            [] k $ %{} FileEntry
                              :ns $ %{} CodeEntry (:doc |)
                                :code $ transform-code (:ns file)
                              :defs $ -> (:defs file)
                                map-kv $ fn (def-name code)
                                  [] def-name $ %{} CodeEntry (:doc |)
                                    :code $ transform-code code
                -> next (dissoc :ir)
                  assoc :package $ get-in next ([] :ir :package)
                  assoc :files $ get-in next ([] :ir :files)
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            app.config :refer $ dev?
            respo-ui.css :as css
            |copy-text-to-clipboard :default copy!
    |app.config $ %{} :FileEntry
      :defs $ {}
        |dev? $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            def dev? $ = |dev (get-env |mode |release)
          :examples $ []
        |site $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            def site $ {} (:storage-key |workflow)
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote (ns app.config)
    |app.main $ %{} :FileEntry
      :defs $ {}
        |*reel $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
        |dispatch! $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn dispatch! (op)
              when
                and config/dev? $ not= (nth op 0) :states
                js/console.log |Dispatch: op
              reset! *reel $ reel-updater updater @*reel op
          :examples $ []
        |main! $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn main! ()
              println "|Running mode:" $ if config/dev? |dev |release
              if config/dev? $ load-console-formatter!
              render-app!
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
              flipped js/setInterval 60000 persist-storage!
              let
                  raw $ js/localStorage.getItem (:storage-key config/site)
                when (some? raw)
                  dispatch! $ :: :hydrate-storage
                    assoc (parse-cirru-edn raw) :interacted? false
              println "|App started."
          :examples $ []
        |mount-target $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            def mount-target $ .!querySelector js/document |.app
          :examples $ []
        |persist-storage! $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn persist-storage! () (js/console.log |persist)
              js/localStorage.setItem (:storage-key config/site)
                format-cirru-edn $ :store @*reel
          :examples $ []
        |reload! $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
        |render-app! $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.main $ :require
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
    |app.schema $ %{} :FileEntry
      :defs $ {}
        |store $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            def store $ {}
              :states $ {}
                :cursor $ []
              :interacted? false
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote (ns app.schema)
    |app.updater $ %{} :FileEntry
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |) (:schema nil)
          :code $ quote
            defn updater (store op op-id op-time)
              tag-match op
                  :states cursor s
                  update-states store cursor s
                (:hydrate-storage data) data
                (:interact) (assoc store :interacted? true)
                _ $ do (println "|unknown op:" op) store
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
