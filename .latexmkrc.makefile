INPUT=thesis.tex

all:
    latexmk -pvc $(INPUT)

clean:
    latexmk -CA $(INPUT)
    find . -name *.aux -delete
    find . -name *.log -delete
    rm *.bbl

view:
    latexmk -pv $(INPUT)
