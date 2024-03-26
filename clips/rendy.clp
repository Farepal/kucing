(deftemplate user-data
    (slot user-fact)
    (slot cf)
)

(deftemplate pertanyaan
    (slot id)
    (slot pertanyaan (default ?NONE))
    (slot status (default FALSE))
)

(deftemplate rekomendasi
    (slot id)
    (slot genre)
    (slot cf)
)

(deffunction durkin-form (?cf1 ?cf2)
  (if (and (> ?cf1 0) (> ?cf2 0)) then
    (return (+ ?cf1 (* ?cf2 (- 1 ?cf1)))))
  (if (or (and(<= ?cf1 0)(>= ?cf2 0))(and (<= ?cf2 0)(>= ?cf1 0)) ) then
    (return (/ (+ ?cf1 ?cf2) (- 1 (min (abs ?cf1) (abs ?cf2))))))
  (if (and (<= ?cf1 0) (<= ?cf2 0)) then
    (return (+ ?cf1 (* ?cf2 (+ ?cf1 1)))))
)

(defrule start
    (declare (salience 10000))
    =>
    (set-fact-duplication TRUE)
    (printout t "" crlf)
    (printout t "Rekomendari genre game yang kamu banget" crlf)
    (printout t "" crlf)
    (printout t "Jawaban yang bisa terbaca:" crlf)
    (printout t "-------------------------------------" crlf)
    (printout t " Nilai           Jawaban " crlf)
    (printout t "-------------------------------------" crlf)
    (printout t " -1              Sangat Tidak Setuju "	crlf)
    (printout t " -0.66           Hampir Tidak Setuju "	crlf)
    (printout t " -0.33           Mungkin Tidak"	crlf)
    (printout t "  0              Tidak Tahu "	crlf)
    (printout t "  0.33           Mungkin "	crlf)
    (printout t "  0.66           Hampir Setuju "	crlf)
    (printout t "  1              Sangat Setuju "	crlf)
    (printout t "-------------------------------------" crlf)
    (printout t "Kamu bisa mengisi angka antara -1 hingga 1 dengan petunjuk seperti yang tertera!" crlf)
    (printout t "" crlf)
)

(deffacts pertanyaan-untuk-user
    (pertanyaan (id oke-modeaksi) (pertanyaan "Apakah anda suka bermain untuk mengalahkan musuh?") (status FALSE))
    (pertanyaan (id oke-modecerita) (pertanyaan "Apakah anda suka melihat cerita dan pengembangan karakter di game anda?") (status FALSE))
    (pertanyaan (id oke-taktik) (pertanyaan "Apakah anda suka bermain taktik?") (status FALSE))
    (pertanyaan (id oke-linear) (pertanyaan "Apakah anda suka dengan game yang linear?") (status FALSE))
    (pertanyaan (id oke-multi) (pertanyaan "Apakah anda suka bermain online atau bersama teman?") (status FALSE))
    (pertanyaan (id oke-kompe) (pertanyaan "Apakah anda orang yang kompetitif?") (status FALSE))
)

(defrule bertanya
    (pertanyaan (status FALSE))
    ?q <- (pertanyaan (id ?id) (pertanyaan ?pertanyaan) (status FALSE))
    =>
    (printout t ?pertanyaan crlf)
    (bind ?cf (read))
    (assert (user-data (user-fact ?id) (cf ?cf)))
    (modify ?q (status TRUE))
)

(defrule aksi
    (declare (salience -5))
    (user-data (user-fact oke-modeaksi) (cf ?cf1))
    (user-data (user-fact oke-modecerita) (cf ?cf2))
    (user-data (user-fact oke-multi) (cf ?cf3))
    (user-data (user-fact oke-kompe) (cf ?cf4))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (bind ?cf (durkin-form ?cf ?cf3))
    (bind ?cf (durkin-form ?cf ?cf4))
    (assert (rekomendasi (id aks) (genre "Aksi") (cf ?cf)) )
)

(defrule petualang
    (declare (salience -5))
    (user-data (user-fact oke-modecerita) (cf ?cf1))
    (user-data (user-fact oke-linear) (cf ?cf2))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (assert (rekomendasi (id pet) (genre "Petualang") (cf ?cf)) )
)

(defrule rpg
    (declare (salience -5))
    (user-data (user-fact oke-modeaksi) (cf ?cf1))
    (user-data (user-fact oke-modecerita) (cf ?cf2))
    (user-data (user-fact oke-linear) (cf ?cf3))
    (user-data (user-fact oke-multi) (cf ?cf4))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (bind ?cf (durkin-form ?cf ?cf3))
    (bind ?cf (durkin-form ?cf ?cf4))
    (assert (rekomendasi (id rpg) (genre "RPG") (cf ?cf)) )
)

(defrule strategi
    (declare (salience -5))
    (user-data (user-fact oke-taktik) (cf ?cf1))
    (user-data (user-fact oke-multi) (cf ?cf2))
    (user-data (user-fact oke-kompe) (cf ?cf3))

    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (bind ?cf (durkin-form ?cf ?cf3))
    (assert (rekomendasi (id str) (genre "Strategi") (cf ?cf)) )
)

(defrule puzzle
    (declare (salience -5))
    (user-data (user-fact oke-taktik) (cf ?cf1))
    (user-data (user-fact oke-multi) (cf ?cf2))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (assert (rekomendasi (id puz) (genre "Puzzle") (cf ?cf)) )
)

(defrule fps
    (declare (salience -5))
    (user-data (user-fact oke-modeaksi) (cf ?cf1))
    (user-data (user-fact oke-taktik) (cf ?cf2))
    (user-data (user-fact oke-multi) (cf ?cf3))
    (user-data (user-fact oke-kompe) (cf ?cf4))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (bind ?cf (durkin-form ?cf ?cf3))
    (bind ?cf (durkin-form ?cf ?cf4))
    (assert (rekomendasi (id fps) (genre "FPS") (cf ?cf)) )
)

(defrule simulasi
    (declare (salience -5))
    (user-data (user-fact oke-modeaksi) (cf ?cf1))
    (user-data (user-fact oke-multi) (cf ?cf2))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (assert (rekomendasi (id sim) (genre "Simulasi") (cf ?cf)) )
)

(defrule olahraga
    (declare (salience -5))
    (user-data (user-fact oke-taktik) (cf ?cf1))
    (user-data (user-fact oke-multi) (cf ?cf2))
    (user-data (user-fact oke-kompe) (cf ?cf3))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (bind ?cf (durkin-form ?cf ?cf3))
    (assert (rekomendasi (id ola) (genre "Olahraga") (cf ?cf)) )
)

(defrule horror
    (declare (salience -5))
    (user-data (user-fact oke-modeaksi) (cf ?cf1))
    (user-data (user-fact oke-modecerita) (cf ?cf2))

    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (assert (rekomendasi (id hor) (genre "Horror") (cf ?cf)) )
)

(defrule mmo
    (declare (salience -5))
    (user-data (user-fact oke-modeaksi) (cf ?cf1))
    (user-data (user-fact oke-modecerita) (cf ?cf2))
    (user-data (user-fact oke-multi) (cf ?cf3))
    (user-data (user-fact oke-kompe) (cf ?cf4))
    
    =>
    (bind ?cf (durkin-form ?cf1 ?cf2))
    (bind ?cf (durkin-form ?cf ?cf3))
    (bind ?cf (durkin-form ?cf ?cf4))
    (assert (rekomendasi (id mmo) (genre "MMO") (cf ?cf)) )
)

(defrule print-result
    (declare (salience -10))
    (rekomendasi (id aks) (genre ?g1) (cf ?cf1))
    (rekomendasi (id pet) (genre ?g2) (cf ?cf2))
    (rekomendasi (id rpg) (genre ?g3) (cf ?cf3))
    (rekomendasi (id str) (genre ?g4) (cf ?cf4))
    (rekomendasi (id puz) (genre ?g5) (cf ?cf5))
    (rekomendasi (id fps) (genre ?g6) (cf ?cf6))
    (rekomendasi (id sim) (genre ?g7) (cf ?cf7))
    (rekomendasi (id ola) (genre ?g8) (cf ?cf8))
    (rekomendasi (id hor) (genre ?g9) (cf ?cf9))
    (rekomendasi (id mmo) (genre ?g10) (cf ?cf10))

    =>
    (printout t "Berdasarkan isi survey anda, berikut hasil rekomendasi genre game yang anda suka " crlf)
    (printout t "------------------------------------ "crlf)
    (printout t "Tingkat Rekomendasi   genre" crlf)
    (printout t "----------------------------------- " crlf)
    (printout t ?cf1 "                " ?g1 crlf)
    (printout t ?cf2 "                " ?g2 crlf)
    (printout t ?cf3 "                " ?g3 crlf)
    (printout t ?cf4 "                " ?g4 crlf)
    (printout t ?cf5 "                " ?g5 crlf)
    (printout t ?cf6 "                " ?g6 crlf)
    (printout t ?cf7 "                " ?g7 crlf)
    (printout t ?cf8 "                " ?g8 crlf)
    (printout t ?cf9 "                " ?g9 crlf)
    (printout t ?cf10 "                " ?g10 crlf)
    (printout t "----------------------------------- " crlf)
)

(defrule tidak-semua
    (declare (salience -100))
    (user-data (user-fact oke-modeaksi) (cf ?cf1))
    (user-data (user-fact oke-modecerita) (cf ?cf2))
    (user-data (user-fact oke-taktik) (cf ?cf3))
    (user-data (user-fact oke-linear) (cf ?cf4))
    (user-data (user-fact oke-multi) (cf ?cf5))
    (user-data (user-fact oke-kompe) (cf ?cf6))
    =>
    (if (and (< ?cf1 0) (< ?cf2 0) (< ?cf3 0) (< ?cf4 0) (< ?cf5 0) (< ?cf6 0)) then
        (printout t "Mungkin tidak ada Genre game yang menarik untuk kamu di list ini" crlf))
)


