#!/bin/sh
# ref: https://www.xach.com/lisp/buildapp/

buildapp --output solve-sudoku \
         --load-system solve-sudoku \
         --entry screamer-user:ui
