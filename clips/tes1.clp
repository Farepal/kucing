(defrule ref49
    (base-oil 1)
    (saponification-agent 1)
    (viscosity-range 1)
    (temperature-range 1)
    (requirement 1)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "AVIALITH 1 EP" crlf "BECHEM High-Lub LT 1 EP" crlf "G.A. N.70 EP-1" crlf "Spheerol EPL 1" crlf "Tribol GR 100-1 PD" crlf "Multifak EP 1" crlf "GR MU/EP 1" crlf "RENOLIT FEP 1" crlf "LAGERMEISTER BF 1" crlf "Klüberplex BEM 41-141" crlf "KEP 1" crlf "Polyflex EP 1-160" crlf "Mobilgrease XHP 221" crlf "Grease Li EP 1" crlf "Precision General Purpose EP 1" crlf "GRASA LÍTICA EP 1" crlf "Gadus S2 V220 1" crlf "Multis EP 1" crlf))

(defrule re55
    (base-oil 1 | 2 | 3)
    (saponification-agent 1)
    (viscosity-range 1)
    (temperature-range 1)
    (requirement 2)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "ARALUB HLP 2" crlf "BECHEM High-Lub LT 2 EP" crlf "G.A. N.70 EP-2" crlf "Spheerol EPL 2" crlf "Tribol GR 100-2 PD" crlf "Multifak EP 2" crlf "GR MU/EP 2" crlf "RENOLIT FEP 2" crlf "LAGERMEISTER EP 2" crlf "Klüberplex BEM 41-132" crlf "KEP 2" crlf "Polyflex EP 2-160" crlf "Mobilith SHC 220" crlf "Grease Li EP 2" crlf "Precision General Purpose EP 2" crlf "GRASA LÍTICA EP 2" crlf "Gadus S2 V220 2" crlf "Multifak 142" crlf "Multis EP 2" crlf))

(defrule ref60
    (base-oil 1)
    (saponification-agent 1 | 2)
    (viscosity-range 1)
    (temperature-range 2)
    (requirement 3)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "LITHOPLEX 2 EP" crlf "Beruplex Li EP 2" crlf "G.A. PLEX-2" crlf "Spheerol EPLX 200-2" crlf "Tribol GR 4020/220-2 PD" crlf "RENOLIT DURAPLEX EP 2" crlf "LAGERMEISTER LX EP 2" crlf "Klüberplex BEM 41-132" crlf "KL Complex 150" crlf "Thermoflex EP 2-180" crlf "Mobilith SHC 220" crlf "Grease LiX EP 2/170" crlf "Precision XL EP 2" crlf "GRASA LÍTICA COMPLEJA INDUSTRIA" crlf "Gadus S3 V220 C" crlf "Starplex EP 2" crlf "Multis Complex EP 2" crlf))

(defrule ref62
    (base-oil 1 | 2 | 3)
    (saponification-agent 1 | 2)
    (viscosity-range 2)
    (temperature-range 3)
    (requirement 4)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "BECHUM High-Lub LM 2 EP" crlf "G. BESLUX PLEX L-2 EP" crlf "Spheerol EPLX 200-2" crlf "RENOLIT HLT 2" crlf "STABYL LT 50" crlf "Klüberplex BEM 41-132" crlf "Synthoflex 2-100" crlf "Mobilith SHC 100" crlf "Gadus S5 V100 2" crlf))

(defrule ref63
    (base-oil 1 | 2 | 3)
    (saponification-agent 1 | 2)
    (viscosity-range 3)
    (temperature-range 3)
    (requirement 5)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "G. BESLUX LIPLEX M-1/2 S" crlf "Spheerol SY 2202" crlf "Tribol GR 4747/220-2 HT" crlf "RENOLIT HI-TEMP 220" crlf "GEARMASTER LI 400" crlf "MICROLUBE GB 00" crlf "KEP 00" crlf "Synthoflex 2-220" crlf "Mobilith SHC 220" crlf "Precision XL EP 00" crlf "GRASA LÍTICA CENTRALIZADOS" crlf "Gadus S5 V220 2" crlf "Multis EP 00" crlf))

(defrule ref66
    (base-oil 1)
    (saponification-agent 1 | 2)
    (viscosity-range 1)
    (temperature-range 1)
    (requirement 6)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "Lithoplex 00 EP" crlf "BECHEM High-Lub LT 0 EP" crlf "G.A. N.850 EP-00" crlf "Spheerol EPL 00" crlf "Tribol GR-100-00 PD" crlf "RENOLIT DURAPLEX EP 00" crlf "Polyflex EP 00-160" crlf "Gadus S2 V220 00" crlf "Marfak 00" crlf))

(defrule ref150and151
    (base-oil 1)
    (saponification-agent 1)
    (viscosity-range 4)
    (temperature-range 1)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "Tribol GR 3020/1000-00 PD" crlf "Multifak EP 000" crlf "KEC" crlf "Carboflex OG 000-1500 HD" crlf "Carboflex Arctic OG 900 HD" crlf "Mobilux EP 023" crlf "MULTIS EP 000" crlf "BECHEM High-Lub LT 0 EP" crlf "Spherol EPL 00" crlf "Tribol GR 3020/1000-00 PD" crlf "RENOLIT DURAPLEX EP 00" crlf "GEARMASTER LI 400" crlf "KEP 00" crlf "Polyflex EP00-160" crlf "Grease Li EP 00" crlf "Gadus S2 V220 00" crlf "MULTIS EP 00" crlf))

(defrule ref155and156
    (base-oil 1)
    (saponification-agent 1)
    (viscosity-range 4)
    (temperature-range 3)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "Tribol GR 3020/1000-00 PD" crlf "Multifak EP 000" crlf "KEC" crlf "Carboflex OG 000-1500 HD" crlf "Carboflex Arctic OG 900 HD" crlf "Tribol GR 3020/1000-00 PD" crlf "GEARMASTER LI 400" crlf "Gadus S2 V220 00" crlf))

(defrule ref160
    (base-oil 2)
    (saponification-agent 3)
    (viscosity-range 5)
    (temperature-range 4)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "Mobiltemp SHC 100" crlf))

(defrule ref161
    (base-oil 2)
    (saponification-agent 3)
    (viscosity-range 6)
    (temperature-range 5)
=>
(printout t crlf "Berikut list pelumas yang bisa digunakan:" crlf "Mobiltemp SHC 32" crlf))

(defrule input
    (initial-fact)
    =>
    (printout t crlf "Base Oil (1: Mineral Oil, 2: PAO, 3: Mixtures) ")
    (assert (base-oil =(read)))
    (printout t crlf "Saponification Agent (1: Lithium, 2: Lithium Complex, 3: Bentonite) ")
    (assert (saponification-agent =(read)))
    (printout t crlf "Base oil viscosity mm²/s at 40 °C (1: 100-220, 2: approx 100, 3: approx 220, 4: approx 220-1000, 5: 100, 6: 32) ")
    (assert (viscosity-range =(read)))
    (printout t crlf "Minimum temperature range (1: -20 to 120, 2: -20 to 140, 3: -40 to 120, 4: -50 to 200, 5: -50 to 180) ")
    (assert (temperature-range =(read)))
    (printout t crlf "Minimum requirements acc. to DIN 51502 (1: KP1K-20, 2: KP2K-20, 3: KP2N-20, 4: KP(HC)2K-40, 5: KP(HC)2N-40, 6: GP00K-20) ")
    (assert (requirement =(read)))
    (printout t crlf "" crlf))