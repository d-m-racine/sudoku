;;; solve-sudoku: Constraint propagation with Screamer (nikodemus.github.io/screamer)
;;; Reads 81 whitespace-delimited symbols from standard input, each a digit [1-9]
;;; or a placeholder such as a hyphen or underscore. Input is assumed to represent
;;; a solvable sudoku in which case the solution is printed to standard output.
;;; D. Racine 20180609

(in-package :screamer-user)

;; Sudoku grids will be represented as lists of 81 squares. Each square is a member
;; of three 9-member units: its row, its column, and its 3x3 box. The following 3
;; functions divide a grid into its constituent units. Each function returns a list
;; of 9 units, each a list of 9 squares.

(defun rows (grid) (when grid (cons (subseq grid 0 9) (rows (subseq grid 9)))))
    
(defun columns (grid) (apply #'mapcar #'list (rows grid)))

(defun boxes (grid)
  (labels ((seq3 (r c) (subseq grid (+ (* 9 r) c) (+ (* 9 r) c 3)))
           (box (r c) (apply #'append (mapcar (lambda (x) (seq3 (+ r x) c)) '(0 1 2)))))
    (mapcar #'box '(0 0 0 3 3 3 6 6 6) '(0 3 6 0 3 6 0 3 6))))


(defun make-vgrid (puzzle)
  "Returns a grid with all placeholders replaced with logic variables constrained
  to be integers between 1 and 9."
  (mapcar (lambda (x) (if (and (integerp x) (<= 1 x 9))
                          x
                          (an-integer-betweenv 1 9)))
          puzzle))


(defun constrain-all-units-to-have-no-duplicate-members (vgrid)
  (dolist (u (append (rows vgrid) (columns vgrid) (boxes vgrid)))
    (assert! (apply #'/=v u))))


(defun solve-sudoku (puzzle)
  (let ((g (make-vgrid puzzle)))
    (constrain-all-units-to-have-no-duplicate-members g)
    (one-value (solution g (static-ordering #'linear-force)))))


(defun print-grid (g)
  (dolist (i (rows g))
    (format t "~&~a~%" (string-trim "()" (princ-to-string i)))))


(defun read-solve-print (argv)
  (let ((p (loop with i while (setq i (read *standard-input* nil)) collect i)))
    (if (= (length p) 81)
        (print-grid (solve-sudoku p))
        (error (concatenate
                'string (princ-to-string (length p))
                " symbols were read from standard input, 81 were expected")))))
