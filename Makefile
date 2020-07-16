#!/usr/bin/make -f

SHELL = bash
VERSION?=$(shell git describe --abbrev=8 --dirty --always)
DATE?= `LC_ALL=en_US date "+%B %e, %Y"`

BUILD_DIR = build
OUT_DIR = output

PDF_NAME?= "neofs-spec-${VERSION}.pdf"
TEX_NAME?= "neofs-spec-${VERSION}.tex"
PARTS = $(shell find . -mindepth 2 -maxdepth 2 -type f -name '*.md' | sort)

.PHONY: all pdf directories view clean

all: pdf html

directories: $(OUT_DIR) $(BUILD_DIR)

pdf: $(OUT_DIR)/$(PDF_NAME)

view:
	type xdg-open >/dev/null 2>&1 && xdg-open $(OUT_DIR)/$(PDF_NAME) || open $(OUT_DIR)/$(PDF_NAME)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/$(PDF_NAME): | directories
	pandoc \
	$(PARTS) \
	-M date="$(DATE)" \
	-M version="$(VERSION)" \
	--template=templates/eisvogel.latex \
	--default-image-extension=pdf \
	-H templates/style.pandoc \
	-F pandoc-crossref \
	-F pandoc-plantuml \
	--toc \
	--listings \
	-o $(BUILD_DIR)/$(TEX_NAME) && \
	latexmk -r 'templates/glossaries.latexmk' \
	-pdflatex='xelatex %O %S' \
	-outdir=$(BUILD_DIR) \
	-pdf $(BUILD_DIR)/$(TEX_NAME) && \
	mv $(BUILD_DIR)/$(PDF_NAME) $@

html: | directories
	pandoc  --no-highlight \
	$(PARTS) \
	-M date="$(DATE)" \
	-M version="$(VERSION)" \
	--default-image-extension=svg \
  --from markdown+smart+yaml_metadata_block+auto_identifiers \
  --to html5 \
  --output $(OUT_DIR)/index.html

.PHONY: image docker_build

image:
	docker build -t 'nspccdev/neofs-spec' .

docker/%:
	docker run --rm -it -v `pwd`:/src -u `stat -c "%u:%g" .` nspccdev/neofs-spec:latest make $$(basename $@)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUT_DIR)
