(defn score [hand] 
  (let
    [ freqs (reverse (sort (vals (frequencies hand)))) ]
    (cond
      (= 1 (first freqs))
      100
      (= 2 (first freqs))
      (if (= 1 (second freqs))
        200
        300)
      (= 3 (first freqs))
      (if (= 1 (second freqs))
        400
        500)
      (= 4 (first freqs))
      600
      (= 5 (first freqs))
      700
      :else
      (throw "HUH???"))))

(def lines
  (str/split-lines
    (slurp *in*)))

(def hands
  (map
    (fn [x]
      (first (str/split x (re-pattern " "))))
    lines))

(def replaced-hands
  (map
    (fn [hand]
      (-> hand
        (str/replace (re-pattern "2") "a")
        (str/replace (re-pattern "3") "b")
        (str/replace (re-pattern "4") "c")
        (str/replace (re-pattern "5") "d")
        (str/replace (re-pattern "6") "e")
        (str/replace (re-pattern "7") "f")
        (str/replace (re-pattern "8") "g")
        (str/replace (re-pattern "9") "h")
        (str/replace (re-pattern "T") "i")
        (str/replace (re-pattern "J") "j")
        (str/replace (re-pattern "Q") "k")
        (str/replace (re-pattern "K") "l")
        (str/replace (re-pattern "A") "m")))
    hands))

(def bids
  (map
    (fn [x]
      (Integer/parseInt (second (str/split x (re-pattern " ")))))
    lines))

(def scores
  (map score hands))

(def keys
  (map str
    scores
    replaced-hands))

(def zipped
  (zipmap bids keys))

(def sorted
  (sort-by zipped bids))

(pprint 
  (sort-by val zipped))

(print
  (first
    (reduce
      (fn [[acc rank] bid]
        (vector
          (+ acc (* bid rank))
          (inc rank)))
      [0 1]
      sorted)))


