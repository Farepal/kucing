(deftemplate fact
   (slot name)
   (slot cf))

(deffacts initial-facts
   (fact (name "machine-status")  (cf 0.8))
   (fact (name "inventory-level")  (cf 0.6))
   (fact (name "order-backlog")  (cf 0.7))
   (fact (name "customer-satisfaction")  (cf 0.6))
)

(deffunction calc-cf (?cf1 ?cf2)
  (if (and (> ?cf1 0) (> ?cf2 0))
    then
      (+ ?cf1 (* ?cf2 (- 1 ?cf1)))If both CFs are positive
    else
      (if (and (< ?cf1 0) (< ?cf2 0))
        then
          (+ ?cf1 (* ?cf2 (+ 1 ?cf1)))If both CFs are negative
        else
          (/ (+ ?cf1 ?cf2) (- 1 (min (abs ?cf1) (abs ?cf2))))If CFs have opposite signs
      )
  )
)


; Jika mesin operasional (certainty tinggi) dan backlog order tinggi (certainty sedang),
; maka perlu peningkatan kapasitas produksi.
(defrule increase-production-capacity
   (fact (name "machine-status")  (cf ?cf1&:(>= ?cf1 0.75)))
   (fact (name "order-backlog")  (cf ?cf2&:(>= ?cf2 0.5)))
   =>
   (printout t "Increase production capacity." crlf)
   (assert (fact (name "production-capacity-increase-recommendation")  (cf (calc-cf ?cf1 ?cf2)))))

; Jika mesin tidak operasional atau kepuasan pelanggan rendah,
; maka tindakan perbaikan mesin atau pelayanan pelanggan perlu ditingkatkan.
(defrule improve-machines-if-needed
   (fact (name "machine-status")  (cf ?cf1&:(> ?cf1 0)))
   =>
   (printout t "Take action to improve machines." crlf)
   (assert (fact (name "improvement-action-machine")  (cf ?cf1))))

(defrule improve-services-if-needed
   (fact (name "customer-satisfaction")  (cf ?cf1&:(> ?cf1 0)))
   =>
   (printout t "Take action to improve customer services." crlf)
   (assert (fact (name "improvement-action-service")  (cf ?cf1))))

; ika tingkat inventori rendah dan kepuasan pelanggan baik,
;pertimbangkan untuk mempercepat pengiriman barang.
(defrule expedite-shipping
   (fact (name "inventory-level")  (cf ?cf1&:(> ?cf1 0.5)))
   (fact (name "customer-satisfaction")  (cf ?cf2&:(> ?cf2 0.5)))
   =>
   (printout t "Consider expediting shipping." crlf)
   (assert (fact (name "expedite-shipping-recommendation")  (cf (calc-cf ?cf1 ?cf2)))))

;Jika mesin membutuhkan perawatan (certainty tinggi) atau backlog order rendah,
;jadwalkan perawatan untuk menghindari kerusakan yang tidak terduga.
(defrule schedule-maintenance-if-needed
   (fact (name "machine-maintenance-required")  (cf ?cf1&:(> ?cf1 0.7)))
   =>
   (printout t "Schedule machine maintenance due to maintenance requirement." crlf)
   (assert (fact (name "maintenance-scheduling-required")  (cf ?cf1))))

(defrule schedule-maintenance-if-low-backlog
   (fact (name "order-backlog")  (cf ?cf2&:(<= ?cf2 0.3)))Note: Changed condition to reflect "low" backlog
   =>
   (printout t "Schedule machine maintenance due to low order backlog." crlf)
   (assert (fact (name "maintenance-scheduling-low-backlog")  (cf ?cf2))))


;Jika produksi efisien dan mesin operasional,
;tidak perlu perubahan dalam proses produksi saat ini.
(defrule maintain-production-process
   (and
      (fact (name "production-efficiency")  (cf ?cf1&:(> ?cf1 0.6)))
      (fact (name "machine-status")  (cf ?cf2&:(> ?cf2 0.8))))
   =>
   (printout t "Maintain current production process." crlf)
   (assert (fact (name "production-process-change")  (cf (calc-cf ?cf1 ?cf2)))))

;Jika ada faktor eksternal negatif yang berdampak pada produksi,
;pertimbangkan untuk merevisi estimasi output.
(defrule revise-output-estimation
   (fact (name "external-factor")  (cf ?cf1&:(< ?cf1 0)))
   =>
   (printout t "Revise production output estimation due to external factors." crlf)
   (assert (fact (name "output-estimation-revision")  (cf ?cf1))))

;Jika kepuasan pelanggan rendah dan tingkat inventori tinggi,
;ini bisa menjadi indikasi masalah kualitas produk, lakukan investigasi lebih lanjut.
(defrule investigate-product-quality
   (and
      (fact (name "customer-satisfaction")  (cf ?cf1&:(< ?cf1 0)))
      (fact (name "inventory-level")  (cf ?cf2&:(> ?cf2 0.5))))
   =>
   (printout t "Investigate product quality issues." crlf)
   (assert (fact (name "quality-investigation")  (cf (calc-cf ?cf1 ?cf2)))))