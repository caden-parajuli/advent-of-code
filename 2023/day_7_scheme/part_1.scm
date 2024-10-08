(use-modules (ice-9 textual-ports)
             (srfi srfi-1))

(define filename "input")

(define (read_input filename)
  (call-with-input-file filename
    (lambda (file)
      (let lp ((lines '())
               (line (get-line file)))
        (if (eof-object? line)
          lines
          (lp (cons line lines) (get-line file)))))))

(define (cardval card)
  (case card
    ((#\2) 0)
    ((#\3) 1)
    ((#\4) 2)
    ((#\5) 3)
    ((#\6) 4)
    ((#\7) 5)
    ((#\8) 6)
    ((#\9) 7)
    ((#\T) 8)
    ((#\J) 9)
    ((#\Q) 10)
    ((#\K) 11)
    ((#\A) 12)))

(define (score hand)
  (let* ((cardss (car (string-split hand #\ )))
         (cardsl (string->list cardss)))
    (letrec ((lp (lambda (cards head tail two two_pair three four five two_char val)
                   (if (eq? tail '())
                     `(,(cond
                          (five 6)
                          (four 5)
                          ((and three two) 4)
                          (three 3)
                          (two_pair 2)
                          (two 1)
                          (else 0))
                        ,(+ (* val 13) (cardval head)))
                     (let* ((count (string-count cards head))
                            (ntwo (or two (eq? count 2)))
                            (ntwo_pair (or two_pair (and two (eq? count 2) (not (eq? two_char head)))))
                            (nthree (or three (eq? count 3)))
                            (nfour (or four (eq? count 4)))
                            (nfive (or five (eq? count 5))))
                       (lp cards (car tail) (cdr tail) ntwo ntwo_pair nthree nfour nfive (if (and ntwo (not two)) head two_char) (+ (* val 13) (cardval head))))))))
      (lp cardss (car cardsl) (cdr cardsl) #f #f #f #f #f #\c 0))))

(define (hand_less hand1 hand2)
  (let* ((cards1s (car (string-split hand1 #\ )))
         (cards2s (car (string-split hand2 #\ )))
         (cards1 (string->list cards1s))
         (cards2 (string->list cards2s)))
    ;; (letrec ((lp (lambda (cards head tail two two_pair three four five val)
    ;;                (if (eq? tail '())
    ;;                  `(,(cond
    ;;                       (five 6)
    ;;                       (four 5)
    ;;                       ((and three two) 4)
    ;;                       (three 3)
    ;;                       (two_pair 2)
    ;;                       (two 1)
    ;;                       (else 0))
    ;;                     ,(+ (* val 13) (cardval head)))
    ;;                  (let* ((count (string-count cards head))
    ;;                         (ntwo (or two (eq? count 2)))
    ;;                         (ntwo_pair (or two_pair (and two ntwo)))
    ;;                         (nthree (or three (eq? count 3)))
    ;;                         (nfour (or four (eq? count 4)))
    ;;                         (nfive (or five (eq? count 5))))
    ;;                    (lp cards (car tail) (cdr tail) ntwo ntwo_pair nthree nfour nfive (+ (* val 13) (cardval head))))))))

             ;; If efficiency mattered for this, we could compute this score once for each card and sort based on that
             (let* ((score1 (score hand1))
                    (score2 (score hand2)))
               (begin
                 (display hand1) (display " ") (display score1) (display "\n")
                 (display hand2) (display " ") (display score2) (display "\n")
                 (if (= (car score1) (car score2))
                   (< (cadr score1) (cadr score2))
                   (< (car score1) (car score2))))))
  )
  ;; )

(define (points line)
  (string->number (cadr (string-split line #\ ))))

(let* ((hands (sort (read_input filename) hand_less))
       (final (fold 
                (lambda (y ix)
                  (begin
                    (display y)
                    (display "\n")
                  (let ((i (car ix))
                        (x (cadr ix)))
                    `( ,(+ i 1)
                       ,(+ x (* (points y) i))))))
                '(1 0)
                hands
                )))
    (display (cadr final)))

;; (for-each (lambda (line)
;;             (display (hand_less line "7T77A 891"))
;;             (display "\n"))
;;           (read_input filename))
;;
