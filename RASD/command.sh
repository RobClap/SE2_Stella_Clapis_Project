#/bin/bash
evince document.pdf &
latexmk -pvc document.tex -pdf
