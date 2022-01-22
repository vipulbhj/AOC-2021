(ns day20.aoc)
(require '[clojure.string :as str])

(defn produce-all-indexes [idx, size]
  (let [all-indexes [
      (- (- idx size) 1), (- idx size), (+ (- idx size) 1), 
      (- idx 1), idx, (+ idx 1),
      (- (+ idx size) 1), (+ idx size), (+ (+ idx size) 1)
    ]
  ]
  all-indexes
))

(defn get-indexes [count]
  (let [idxes (take count (range))]
      idxes
  )
)

(defn pixel-to-binary [i, pixels, default]
  (let
    [v (get pixels i)]
    (if (nil? v) (if (= default "#") "1" "0") (if (= v "#") "1" "0"))
  )
)

(defn expand-grid [grid, size, default]
  (let [
      empty-row (take (+ size 2) (repeat default))
      middle-rows (reduce (fn [acc, x] (let [row (concat [default] x [default])] (concat acc row))) [] (partition size grid)) 
      new-grid (concat empty-row middle-rows empty-row)
    ]
    (vec new-grid)
  )
)

(defn create-binary-str [idx, size, pixels, default]
  (let [
      connected-indexes (produce-all-indexes idx size)
      binary-str (map (fn [i] (pixel-to-binary i pixels default)) connected-indexes)
    ]
   (str/join "" binary-str)
  )
)

(defn binary-str-to-idx [s] 
  (let 
    [res (Integer/parseInt s 2)]
    res
  )
)

(defn perform-n-times [n, grid, algo, size] 
  (if (= n 0) 
    grid
    (let [
        default (if (or (= (get algo 0) ".") (= (mod n 2) 0)) "." "#")
        expanded-grid (expand-grid grid size default)
        new-size (+ size 2)
        new-grid (map (fn [i] (get algo (binary-str-to-idx (create-binary-str i new-size expanded-grid default)))) (get-indexes (count expanded-grid)))
      ]

      (perform-n-times (- n 1) new-grid algo new-size) 
    )
  )
)

(defn solution []
  (let [
    inp (slurp "input.txt")
    lines (str/split inp #"\n\n")
    algo (str/split (get lines 0) #"")
    data-lines (str/split-lines (get lines 1))
    size (count (get data-lines 0))
    pixels (reduce concat (map (fn [s] (str/split s #"")) data-lines))
    part-one (perform-n-times 2 pixels algo size)
    part-two (perform-n-times 50 pixels algo size)
  ]

  (println (reduce (fn [acc, i] (if (= i "#") (+ acc 1) acc)) 0 part-one))
  (println (reduce (fn [acc, i] (if (= i "#") (+ acc 1) acc)) 0 part-two))
))

(solution)
