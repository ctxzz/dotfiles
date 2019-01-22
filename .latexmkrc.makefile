IN=thesis.tex

all:
	latexmk -pvc $(IN)

clean:
	latexmk -CA $(IN)
	find . -name *.aux -delete
	find . -name *.log -delete
	rm *.bbl

view:
	latexmk -pv $(IN)


