DOT_FILES := $(wildcard graphviz/*.dot)

all: makegraphs makedoc cliean

doc:
	latexmk -pvc DesignDocument.tex -pdf 

graphs:
	dot -Tpng $(DOT_FILES) -O

clean:
	-rm *.out *.log *.fls *.aux *.toc *~ *.fdb_latexmk

view:
	evince DesignDocument.pdf
