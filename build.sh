#!/bin/sh

buildapp --output solve-sudoku \
         --load-system solve-sudoku \
         --entry screamer-user:read-solve-print
