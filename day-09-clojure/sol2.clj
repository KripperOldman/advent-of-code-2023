(require
 '[clojure.string :as str])

(def data (->> (-> (slurp "input.txt")
                   (str/split #"\n"))
               (map #(str/split % #" "))
               (map #(map (fn [n] (Integer/parseInt n)) %))))

(defn diff-seq [s]
  (map (fn [a b] (- b a)) s (rest s)))

(defn diff [s]
  (loop [diffs [s]
         last-diff s]
    (if (every? zero? last-diff)
      diffs
      (let [new-diff (diff-seq last-diff)]
        (recur (conj diffs new-diff)
               new-diff)))))

(defn extrapolate-diffs [diffed]
  (reduce (fn [acc curr]
            (let [val (- (first curr)
                         (first acc))]
              (cons val acc)))
          [0]
          (rest (reverse diffed))))

(defn extrapolate [s]
  (let [diffs (diff s)
        extrapolated (extrapolate-diffs diffs)]
    (first extrapolated)))

(println (->> data
              (map extrapolate)
              (reduce +)))
