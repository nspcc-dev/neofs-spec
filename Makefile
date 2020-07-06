#!/usr/bin/make -f

SHELL = bash
VERSION?=$(shell git describe --abbrev=6 --dirty --always)
DATE?= `LC_ALL=en_US date "+%B %e, %Y"`

BUILD_DIR = build
OUT_DIR = output

PDF_NAME?= "neofs-spec-${VERSION}.pdf"
TEX_NAME?= "neofs-spec-${VERSION}.tex"
PARTS = $(shell find . -mindepth 2 -maxdepth 2 -type f -name '*.md' | sort)

.PHONY: all directories clean

all: $(OUT_DIR)/$(PDF_NAME)

directories: $(OUT_DIR) $(BUILD_DIR)

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
	-H templates/style.pandoc \
	-F pandoc-crossref \
	-F pandoc-plantuml \
	--toc \
	--listings \
	-o $(BUILD_DIR)/$(TEX_NAME) && \
	latexmk -pdflatex='xelatex %O %S' \
	-outdir=$(BUILD_DIR) \
	-pdf $(BUILD_DIR)/$(TEX_NAME) && \
	mv $(BUILD_DIR)/$(PDF_NAME) $@

docker_image:
	docker build -t 'nspcc/neofs-spec' .

docker_build:
	docker run --rm -it -v `pwd`:/src -u `stat -c "%u:%g" .`  nspcc/neofs-spec:latest make

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUT_DIR)
