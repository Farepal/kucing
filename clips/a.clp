; Define the initial facts with CF values for different sensor readings
(deffacts initial-sensor-readings
  (sensor (type temperature) (reading high) (cf 0.7))
  (sensor (type vibration) (reading unusual) (cf 0.6))
  (sensor (type noise) (reading high) (cf 0.5))
  (sensor (type error-message) (reading yes) (cf 0.8))
)

; Define a function to combine CFs according to Durkin's method
(deffunction combine-cfs (?cf1 ?cf2)
  (if (and (> ?cf1 0) (> ?cf2 0))
    then (+ ?cf1 (* (1 - ?cf1) ?cf2)) ; both positive
    else (if (and (< ?cf1 0) (< ?cf2 0))
      then (- ?cf1 (* (1 + ?cf1) ?cf2)) ; both negative
      else (- (+ ?cf1 ?cf2) (* (1 - (min (abs ?cf1) (abs ?cf2))) (abs (+ ?cf1 ?cf2)))) ; opposite signs
    )
)

; Rule when temperature is high and vibration is unusual (conjunctive rule)
(defrule check-maintenance-required
  (sensor (type temperature) (reading high) (cf ?temp-cf))
  (sensor (type vibration) (reading unusual) (cf ?vib-cf))
  =>
  (assert (maintenance-required (cf (combine-cfs ?temp-cf ?vib-cf))))
)

; Rule when noise is high or error message is present (disjunctive rule)
(defrule check-noise-or-error
  (or (sensor (type noise) (reading high) (cf ?noise-cf))
      (sensor (type error-message) (reading yes) (cf ?error-cf)))
  =>
  (assert (maintenance-required (cf (combine-cfs ?noise-cf ?error-cf))))
)

; Rule to combine CFs for maintenance decision when both indications are positive
(defrule combine-positive-maintenance-cfs
  ?f1 <- (maintenance-required (cf ?cf1&:(> ?cf1 0)))
  ?f2 <- (maintenance-required (cf ?cf2&:(> ?cf2 0)))
  (test (neq ?f1 ?f2))
  =>
  (retract ?f1 ?f2)
  (assert (final-maintenance-decision (cf (combine-cfs ?cf1 ?cf2))))
)