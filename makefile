LATEXCMDX=  xelatex -halt-on-error -file-line-error -shell-escape -interaction=nonstopmode -output-directory build/
LATEXCMDL= lualatex -halt-on-error -file-line-error -shell-escape -interaction=nonstopmode -output-directory build/



pdf: | build
	rm -f build/*
	$(LATEXCMDL) Resume.tex </dev/null 
	cp build/Resume.pdf Resume.pdf
	rm -f build/*

build:
	mkdir -p build/