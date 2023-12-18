(require '[clojure.string :as str])

(def input (-> (slurp *in*)
               str/split-lines))

(def header
  "check ← {({⊃⍴⍵}¨('.' (≠⊆⊢) ⍺)) ≡ ⍵}
createPos ← {{((⍵≡'?')+1)⊃(⍵ ('.' '#'))}¨⍵}
cart ← ,∘.,
countPos ← {(check∘⍵)¨⊃cart/(createPos ⍺)}
sumCount ← {+/(⍺ countPos ⍵)}

parseNumbers ← {⍎¨','(≠⊆⊢)⍵}
exec ← {+/{(⊃⍵)sumCount(parseNumbers(2⊃⍵))}¨{' ' (≠⊆⊢) ⍵}¨('|' (≠⊆⊢) ⍵)}

sol ← 0
")

(def execs
  (->> (partition-all 50 input)
       (map (partial interpose "|"))
       (map (partial apply str))
       (map #(str "⎕ ← sol ← sol + exec '" % "'\n"))     
       (apply str)))
   

(print (str header execs))
