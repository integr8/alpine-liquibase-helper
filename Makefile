all: clean prepare pdf html

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	docker pull integr8/alpine-asciidoctor-helper

pdf:
	docker run --rm -v $(CURDIR):/documents/ integr8/alpine-asciidoctor-helper pdf docs/index.adoc

html:
	sudo chown fabioluciano:fabioluciano output -R
	cp docs/resources/image/favicon.ico output
	docker run --rm -v $(CURDIR):/documents/ integr8/alpine-asciidoctor-helper html docs/index.adoc
