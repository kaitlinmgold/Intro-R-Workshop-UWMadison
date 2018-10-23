HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard docs/*.Rmd))
HTML_FILES := $(filter-out docs/_sessionInfo.html, $(HTML_FILES))
R_FILES    := $(patsubst %.R, docs/%.html, $(wildcard Part*.R))

.PHONY: all
all : cleanjunk html

.PHONY : html
html : docs/index.html docs/data.html $(HTML_FILES) $(R_FILES)

docs/index.Rmd : README.md
	sed '1d;2d;6d' $< > $@ # remove first, second, and sixth lines

docs/data.Rmd : data/README.md
	cat docs/data.txt $< > $@

docs/%.Rmd : %.R docs/knitopts.R
	cat docs/knitopts.R $< | sed "s_^\# _\#\' _" > docs/$<
	R --slave -e "knitr::spin('docs/$<', knit = FALSE)"
	$(RM) docs/$<

%.html : %.Rmd docs/footer.html docs/_site.yml docs/styles.css
	R --slave -e "rmarkdown::render_site('$<')"

.PHONY : clean
clean :
	$(RM) $(R_FILES)
	R --slave -e "rmarkdown::clean_site('docs')"

.PHONY : cleanjunk
cleanjunk :
	$(RM) -r results/
	$(RM) -r data/FungicideTidy.csv