DOT_FILES := $(wildcard graphviz/*.dot)


all: makegraphs makedoc cliean
makedoc:
	latexmk -pvc DesignDocument.tex -pdf 
makegraphs:
	dot -Tpng $(DOT_FILES) -O

clean:
	-rm *.out *.log *.fls *.aux *.toc *~ *.fdb_latexmk
view:
	evince DesignDocument.pdf
