
all: graphs clean view doc 

doc:
	latexmk -pvc DesignDocument.tex -pdf 

graphs:
	dot -Tpng ./graphviz/Component.dot -o ./images/Component.png
	dot -Tpng -Kfdp ./graphviz/Deployment.dot -o ./images/Deployment.png

clean:
	-git rm *.out *.log *.fls *.aux *.toc *~ *.fdb_latexmk

view:
	evince DesignDocument.pdf > /dev/null &
