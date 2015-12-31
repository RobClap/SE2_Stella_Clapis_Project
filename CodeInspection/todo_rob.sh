cat document.tex | sed -n -e '/.*BEGINROBSECTION.*/,/.*ENDROBSECTION.*/p' | grep '%TODO'
