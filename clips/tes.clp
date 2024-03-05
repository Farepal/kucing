(defrule Sencor-1
(weed B)
(crop C | S)
(organic-matter 1)
=>
(printout t crlf "Do not use Sencor!" crlf))
(defrule Sencor-2
(weed B)
(crop C | S)
(organic-matter 2 | 3)
=>
(printout t crlf "Use 3/4 pt/ac of Sencor" crlf))
(defrule Lasso-1
(weed B | G)
(crop C | S)
(organic-matter 1)
=>
(printout t crlf "Use 2 pt/ac of Lasso" crlf))
(defrule Lasso-2
(weed B | G)
(crop C | S)
(organic-matter 2)
=>
(printout t crlf "Use 1 pt/ac of Lasso" crlf))
(defrule Lasso-3
(weed B | G)
(crop C | S)
(organic-matter 3)
=>
(printout t crlf "Use 0.5 pt/ac of Lasso" crlf))
(defrule Bicep-1
(weed B | G)
(crop C)
(organic-matter 1)
=>
(printout t crlf "Use 1.5 pt/ac of Bicep" crlf))
(defrule Bicep-2
(weed B | G)
(crop C)
(organic-matter 2)
=>
(printout t crlf "Use 2.5 pt/ac of Bicep" crlf))
(defrule Bicep-3
(weed B | G)
(crop C)
(organic-matter 3)
=>
(printout t crlf "Use 3 pt/ac of Bicep" crlf))
(defrule input
    (initial-fact)
    =>
    (printout t crlf "What is the crop? (C: corn, S: soybean) ")
    (assert (crop =(read))) ;this line reads what the user types
    (printout t crlf "What is the weed problem? (B: broadleaf, G: grass) ")
    (assert (weed =(read)))
    (printout t crlf "What is the percentage of organic matter content?
    (1: <2%, 2: 2-4%, 3: > 4%) ")
    (assert (organic-matter =(read)))
    (printout t crlf "RECOMMENDATIONS:" crlf))