
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ {}
      :defs $ {}
        |CodeEntry $ %{} :CodeEntry (:doc |)
          :code $ quote
            def CodeEntry $ new-record :CodeEntry :doc :code
        |Expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            def Expr $ new-record :Expr :data :by :at
        |FileEntry $ %{} :CodeEntry (:doc |)
          :code $ quote
            def FileEntry $ new-record :FileEntry :ns :defs
        |Leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            def Leaf $ new-record :Leaf :by :at :text
        |comp-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $ :store reel
                  states $ :states store
                  cursor $ or (:cursor states) ([])
                  state $ or (:data states)
                    {} (:content "\"") (:next-data nil)
                div
                  {} $ :style (merge ui/fullscreen ui/global ui/row)
                  textarea $ {}
                    :value $ :content state
                    :placeholder "\"Content"
                    :class-name css/font-code!
                    :style $ merge ui/expand ui/textarea
                      {} (:white-space :pre) (:font-size 12)
                    :on-input $ fn (e d!)
                      d! cursor $ assoc state :content (:value e)
                  =< 2 nil
                  div
                    {} $ :style (merge ui/column ui/expand)
                    div ({})
                      button $ {} (:style ui/button) (:inner-text "\"Convert Calcit")
                        :on-click $ fn (e d!)
                          d! cursor $ assoc state :next-data nil
                          d! cursor $ assoc state :next-data
                            transform-snapshot $ parse-cirru-edn (:content state)
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text "\"Convert Compact")
                        :on-click $ fn (e d!)
                          d! cursor $ assoc state :next-data nil
                          d! cursor $ assoc state :next-data
                            transform-compact $ parse-cirru-edn (:content state)
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text "\"FileEntry")
                        :on-click $ fn (e d!)
                          d! cursor $ assoc state :next-data nil
                          d! cursor $ assoc state :next-data
                            transform-file-entry $ parse-cirru-edn (:content state)
                    textarea $ {}
                      :value $ format-cirru-edn (:next-data state)
                      :class-name css/font-code!
                      :placeholder "\"data"
                      :style $ merge ui/expand ui/textarea
                        {} (:white-space :pre) (:font-size 12)
                      :disabled true
                  when dev? $ comp-reel (>> states :reel) reel ({})
        |transform-code $ %{} :CodeEntry (:doc |)
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
        |transform-compact $ %{} :CodeEntry (:doc |)
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
        |transform-file-entry $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn transform-file-entry (snapshot)
              update snapshot :files $ fn (files)
                map-kv files $ fn (k v)
                  [] k $ %{} FileEntry
                    :ns $ :ns v
                    :defs $ :defs v
        |transform-snapshot $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn transform-snapshot (snapshot)
              let
                  next $ -> snapshot
                    update-in ([] :ir :files)
                      fn (files)
                        -> files $ map-kv
                          fn (k file)
                            [] k $ -> file
                              update :ns $ fn (ns-data)
                                %{} CodeEntry (:doc "\"")
                                  :code $ transform-code ns-data
                              update :defs $ fn (defs)
                                -> defs $ map-kv
                                  fn (def-name code)
                                    [] def-name $ %{} CodeEntry (:doc "\"")
                                      :code $ transform-code code
                              dissoc :proc
                -> next (dissoc :ir)
                  assoc :package $ get-in next ([] :ir :package)
                  assoc :files $ get-in next ([] :ir :files)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            app.config :refer $ dev?
            respo-ui.css :as css
    |app.config $ {}
      :defs $ {}
        |dev? $ %{} :CodeEntry (:doc |)
          :code $ quote
            def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |site $ %{} :CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:storage-key "\"workflow")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.config)
    |app.main $ {}
      :defs $ {}
        |*reel $ %{} :CodeEntry (:doc |)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |dispatch! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op)
              when
                and config/dev? $ not= op :states
                js/console.log "\"Dispatch:" op
              reset! *reel $ reel-updater updater @*reel op
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! ()
              println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
              if config/dev? $ load-console-formatter!
              render-app!
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
              flipped js/setInterval 60000 persist-storage!
              let
                  raw $ js/localStorage.getItem (:storage-key config/site)
                when (some? raw)
                  dispatch! $ :: :hydrate-storage (parse-cirru-edn raw)
              println "|App started."
        |mount-target $ %{} :CodeEntry (:doc |)
          :code $ quote
            def mount-target $ .!querySelector js/document |.app
        |persist-storage! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn persist-storage! () (js/console.log "\"persist")
              js/localStorage.setItem (:storage-key config/site)
                format-cirru-edn $ :store @*reel
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! "\"ok~" "\"Ok"
              hud! "\"error" build-errors
        |render-app! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
      :ns $ %{} :CodeEntry (:doc |)
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
            "\"./calcit.build-errors" :default build-errors
            "\"bottom-tip" :default hud!
    |app.schema $ {}
      :defs $ {}
        |store $ %{} :CodeEntry (:doc |)
          :code $ quote
            def store $ {}
              :states $ {}
                :cursor $ []
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.schema)
    |app.updater $ {}
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn updater (store op op-id op-time)
              tag-match op
                  :states cursor s
                  update-states store cursor s
                (:hydrate-storage data) data
                _ $ do (println "\"unknown op:" op) store
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
