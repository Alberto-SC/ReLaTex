LATEXCMDX=  xelatex -halt-on-error -file-line-error -shell-escape -interaction=nonstopmode -output-directory build/
LATEXCMDL= lualatex -halt-on-error -file-line-error -shell-escape -interaction=nonstopmode -output-directory build/



pdf: | build
	rm -f build/*
	$(LATEXCMDL) Resume.tex </dev/null 
	cp build/Resume.pdf Resume-English-Alberto-Silva.pdf
	rm -f build/*

build:
	mkdir -p build/

pdfSpanish: | build 
	rm -f build/* 
	$(LATEXCMDL) ResumeSpanish.tex </dev/null
	cp build/ResumeSpanish.pdf CV-Español-Alberto-Silva-Cazares.pdf
	rm -f build/*