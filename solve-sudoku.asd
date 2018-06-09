(in-package :asdf-user)

(defsystem :solve-sudoku
  :depends-on (:screamer)
  :components ((:file "solve-sudoku")))
