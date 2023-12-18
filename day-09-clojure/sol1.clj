(require
 '[clojure.string :as str])

(def data (->> (-> (slurp "input.txt")
                   (str/split #"\n"))
               (map #(str/split % #" "))
               (map #(map (fn [n] (Integer/parseInt n)) %))))

(defn diff-seq [s]
  (map (fn [a b] (- b a)) s (rest s)))

(defn extrapolate [s]
  (let [diffed (loop [diffs [s]
                      last-diff s]
                 (if (every? zero? last-diff)
                   diffs
                   (let [new-diff (diff-seq last-diff)]
                     (recur (conj diffs new-diff)
                            new-diff))))
        extrapolated (reduce (fn [acc curr]
                               (let [val (+ (last acc)
                                            (last curr))]
                                 (conj acc val)))
                             [0]
                             (rest (reverse diffed)))]
    (last extrapolated)))

(println (->> data
              (map extrapolate)
              (reduce +)))
