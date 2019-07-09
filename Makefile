all: clean prepare pdf html post

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	docker pull integr8/alpine-asciidoctor-helper
	mkdir -p output/en output/ptbr

pdf:
	docker run --rm -v $(CURDIR):/documents/ -e 'ASCIIDOCTOR_PLUGIN=asciidoctor-diagram,tel-inline-macro' -e 'ASCIIDOCTOR_PDF_THEMES_DIR=docs/theme/config' -e 'ASCIIDOCTOR_PDF_THEME=integr8' -e 'ASCIIDOCTOR_PDF_FONTS_DIR=docs/theme/fonts' integr8/alpine-asciidoctor-helper pdf docs/index-ptbr.adoc docs/index-en.adoc

html:
	docker run --rm -v $(CURDIR):/documents/ -e 'ASCIIDOCTOR_PLUGIN=asciidoctor-diagram,git-metadata-preprocessor' -e 'ASCIIDOCTOR_PDF_THEMES_DIR=docs/theme/config' -e 'ASCIIDOCTOR_PDF_THEME=integr8' -e 'ASCIIDOCTOR_PDF_FONTS_DIR=docs/theme/fonts' integr8/alpine-asciidoctor-helper html docs/index-ptbr.adoc docs/index-en.adoc

post:
	cp $(CURDIR)/docs/theme/image/favicon-32.png  $(CURDIR)/output/en/favicon.png
	cp $(CURDIR)/docs/theme/image/favicon-32.png  $(CURDIR)/output/ptbr/favicon.png

	mv $(CURDIR)/output/index-ptbr.html $(CURDIR)/output/ptbr/index.html
	mv $(CURDIR)/output/index-en.html $(CURDIR)/output/en/index.html

	mv $(CURDIR)/output/index-ptbr.pdf $(CURDIR)/output/ptbr/doc.pdf
	mv $(CURDIR)/output/index-en.pdf $(CURDIR)/output/en/doc.pdf