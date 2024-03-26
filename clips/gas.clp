(deffacts initial-organism-facts
(organism stain gramneg 0.3)
(organism stain gramneg 0.3)
(organism stain gramneg 0.5)
(organism stain gramneg -0.5)
(organism stain gramneg 0.4)
(organism morpholgy rod 0.7)
(organism morpholgy rod -0.6)
(patient is-a compromised-host 0.8))

(defrule start
(declare (salience 1000))
(initial-fact)
=>
(set-fact-duplication TRUE))

(defrule combine-certainities-both-positive
?fact1 <- (organism ?attribute ?value ?C1&:(>= ?C1 0))
?fact2 <- (organism ?attribute ?value ?C2&:(>= ?C2 0))
(test (neq ?fact1 ?fact2))
=>
(retract ?fact1 ?fact2)
(bind ?C3 (- (+ ?C1 ?C2) (* ?C1 ?C2)))
(assert (organism ?attribute ?value ?C3)))

(defrule combine-certainities-both-negative
?fact1 <- (organism ?attribute ?value ?C1&:(< ?C1 0))
?fact2 <- (organism ?attribute ?value ?C2&:(< ?C2 0))
(test (neq ?fact1 ?fact2))
=>
(retract ?fact1 ?fact2)
(bind ?C3 (+ (+ ?C1 ?C2) (* ?C1 ?C2)))
(assert (organism ?attribute ?value ?C3)))

(defrule combine-certainities-with-opposite-signs
?fact1 <- (organism ?attribute ?value ?C1)
?fact2 <- (organism ?attribute ?value ?C2)
(test (< (* ?C1 ?C2) 0))
(test (neq ?fact1 ?fact2))
=>
(retract ?fact1 ?fact2)
(bind ?C3 (/ (+ ?C1 ?C2) (- 1 (min (abs ?C1) (abs ?C2)))))
(assert (organism ?attribute ?value ?C3)))