#!/usr/bin/make -f

SHELL=bash
VERSION?=$(shell git describe --abbrev=8 --dirty --always)
PLANTUML_BIN?=plantuml
DATE?=`LC_ALL=en_US date "+%B %e, %Y"`

BUILD_DIR = build
OUT_DIR = output

APIV2_DIR = "../neofs-api"
APIV2_DOC_DIR = "20-api-v2"

CONTRACTS_DIR = "../neofs-contract"
CONTRACTS = $(shell echo "${CONTRACTS_DIR}/alphabet")
CONTRACTS_DOC_DIR = "06-blockchain"

PDF_NAME?= "neofs-spec-${VERSION}.pdf"
TEX_NAME?= "neofs-spec-${VERSION}.tex"
PARTS = $(shell find . -mindepth 2 -maxdepth 2 -type f -name '*.md' | sort)
PUMLS = $(shell find . -mindepth 3 -maxdepth 4 -type f -name '*.puml' -o -name '*.plantuml' | sort)
SVGS = $(shell find . -mindepth 3 -maxdepth 4 -type f -name '*.svg' | sort)
HTML_PIC = $(shell find . -mindepth 3 -maxdepth 3 ! -path './${OUT_DIR}/*' ! -path './${BUILD_DIR}/*' -type f -name '*.svg' -o -name '*.png' -o -name '*.jpg')

.PHONY: all pdf html site directories view clean

all: pdf site

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
	-F pandoc-img-glob \
	--toc \
	--highlight-style pygments \
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
	-o $(OUT_DIR)/index.html

.ONESHELL:
pic:
	@for img in ${HTML_PIC}
	do
		path=$$(grep -Po \".\*`basename $$img`.\"* ${OUT_DIR}/index.html | tr -d '\"') && \
		mkdir -p `dirname ${OUT_DIR}/$$path` && \
		cp $$img ${OUT_DIR}/$$path
	done

.PHONY: puml2svg svg2pdf
.ONESHELL:
puml2svg:
	@for img in ${PUMLS}
	do
		$(PLANTUML_BIN) -charset utf8 -tsvg $$img
	done

.ONESHELL:
svg2pdf:
	@for img in $(basename $(SVGS))
	do
		rsvg-convert -f pdf -o $${img}.pdf $${img}.svg
	done

site: html pic

.PHONY: update_api update_api_v2

.ONESHELL:
update_api_v2:
	@for f in `find ${APIV2_DIR} -type f -name '*.proto' -exec dirname {} \; | sort -u `;
	do
		echo "Documentation for $$(basename $$f)";
		protoc \
			--doc_opt=templates/apiv2-package.tmpl,$${f}.md \
			--proto_path=${APIV2_DIR}:/usr/local/include \
			--doc_out=${APIV2_DOC_DIR} $${f}/*.proto;
	done

update_api: update_api_v2

.PHONY: update_contracts

.ONESHELL:
update_contracts:
	@for f in `find ${CONTRACTS_DIR} -mindepth 2 -maxdepth 2 -type f ! -path '*/nns/*' -name '*_contract.go'  -exec dirname {} \; | sort -u `;
	do
		echo "Documentation for $$(basename $$f)";
		gomarkdoc --template-file file=templates/contracts-file.tmpl \
			--template-file package=templates/contracts-package.tmpl \
			--template-file func=templates/contracts-func.tmpl \
			--template-file doc=templates/contracts-doc.tmpl \
			$$f > ${CONTRACTS_DOC_DIR}/03-$$(basename $$f).md
	done

.PHONY: image docker_build

image:
	docker build -t 'nspccdev/neofs-spec' .

docker/%:
	docker run --rm -it -v `pwd`:/src -u `stat -c "%u:%g" .` nspccdev/neofs-spec:latest make $$(basename $@)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUT_DIR)
