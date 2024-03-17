(defrule p0
        (type-of-lamp LED)
        (nomial-power 4.0)
        (power-factor 0.69)
        (life-span 25)
=>
(printout t crlf "Trade name: Philips Cool Daylight" crlf))

(defrule p1
        (type-of-lamp LED)
        (nomial-power 5.0)
        (power-factor 0.71)
        (life-span 25)
=>
(printout t crlf "Trade name: Philips Warm Daylight" crlf))

(defrule p2
        (type-of-lamp LED)
        (nomial-power 7.0)
        (power-factor 0.72)
        (life-span 25)
=>
(printout t crlf "Trade name: Philips Cool Daylight" crlf))

(defrule p3
        (type-of-lamp LED)
        (nomial-power 4.0)
        (power-factor 0.48)
        (life-span 25)
=>
(printout t crlf "Trade name: Osram Daylight" crlf))

(defrule p4
        (type-of-lamp LED)
        (nomial-power 4.5)
        (power-factor 0.47)
        (life-span 25)
=>
(printout t crlf "Trade name: Osram Warm White" crlf))

(defrule p5
        (type-of-lamp LED)
        (nomial-power 6.0)
        (power-factor 0.5)
        (life-span 25)
=>
(printout t crlf "Trade name: Osram Daylight" crlf))

(defrule p6
        (type-of-lamp LED)
        (nomial-power 8.0)
        (power-factor 0.79)
        (life-span 25)
=>
(printout t crlf "Trade name: Osram Warm White" crlf))

(defrule p7
        (type-of-lamp LED)
        (nomial-power 5.5)
        (power-factor 0.58)
        (life-span 30)
=>
(printout t crlf "Trade name: Toshiba Cool White" crlf))

(defrule p8
        (type-of-lamp LED)
        (nomial-power 5.0)
        (power-factor 0.46)
        (life-span 6)
=>
(printout t crlf "Trade name: Bright cool White" crlf))

(defrule p9
        (type-of-lamp LED)
        (nomial-power 7.0)
        (power-factor 0.48)
        (life-span 20)
=>
(printout t crlf "Trade name: Cash Warm White" crlf))

(defrule p10
        (type-of-lamp LED)
        (nomial-power 3.0)
        (power-factor 0.47)
        (life-span 18)
=>
(printout t crlf "Trade name: Evenzo Cool White" crlf))

(defrule p11
        (type-of-lamp CFL)
        (nomial-power 5.0)
        (power-factor 0.56)
        (life-span 4)
=>
(printout t crlf "Trade name: Philips Genic" crlf))

(defrule p12
        (type-of-lamp CFL)
        (nomial-power 5.0)
        (power-factor 0.59)
        (life-span 3)
=>
(printout t crlf "Trade name: Osram Duluxstar" crlf))

(defrule input
    (initial-fact)
    =>
    (printout t crlf "Type of Lamp (LED or CFL): ")
    (assert (type-of-lamp =(read)))
    (printout t crlf "Nominal Power P[W]: ")
    (assert (nomial-power =(read)))
    (printout t crlf "Power factor [PF]: ")
    (assert (power-factor =(read)))
    (printout t crlf "Life span [Years]: ")
    (assert (life-span =(read)))
    (printout t crlf "" crlf))