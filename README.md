<p align="center">
<img src="./.github/logo.svg" width="500px" alt="NeoFS">
</p>
<p align="center">
  <a href="https://fs.neo.org">NeoFS</a> Technical Specification
</p>

---

## Document format
This document uses a mix of Markdown and LaTeX in [pandoc](https://pandoc.org/) flavors. Target output formats are PDF and HTML.

For non-generated plain text we follow single line paragraph style.

## Build instructions (manual build)
Install pandoc and LaTeX base. Please see Dockerfile for the detailed list of what you might need.

After pandoc and LaTeX base are available, you can simply run `make`, which will generate the specification paper in pdf and html.

## Build using docker
The easiest way to build a specification document is to use [Docker](https://www.docker.com). Just add `docker/` to any Makefile target to run it inside a container having all required tools already available.

* Compile the specification paper pdf using `make docker/pdf`
* Output will be generated as `output/neofs-spec-<revision>.pdf`

You can build docker image locally with `make image` command.

## How to contribute
If you know NeoFS technology and want to contribute, feel free to directly submit a Pull Request with the desired changes.

Initially, the idea is to create a broad and complete initial version of the document, which will be polished in the future.

## Adding pictures
Pictures should be placed in `pic` directory of the corresponding section. Vector formats are preferred and strongly recommended. Please always provide the source file for the picture to allow future edits.

Expected formats:
* [PlantUML](plantuml.com)
* [Draw.io](https://github.com/jgraph/drawio-desktop)
* SVG
* PDF
* PNG
* JPG

When referencing a picture in the document text, please omit file extension. Most appropriate format will be used depending on the document output format.

Example:
```
![Architecture overview](pic/overview-sc2)
```

To render all PlantUML files to SVG run `make puml2svg` or `make docker/puml2svg`

To convert all SVG files to PDF `make svg2pdf` or `make docker/svg2pdf`

### PlantUML
Place [PlantUML](plantuml.com) files under `pic/` directory of the corresponding section and name it with `.puml` or `.plantuml` file extension. It will be automatically rendered to SVG format by `puml2svg` make target.

### Draw.io
[Draw.io](https://github.com/jgraph/drawio-desktop) diagrams must be exported to SVG format and saved under `pic/` directory of corresponding section. To avoid text rendering errors, please follow [this guide](https://desk.draw.io/support/solutions/articles/16000042487). Don't enable `Embed Images` checkbox, or raster image version will be saved in PDF instead of vector image version.

Please palace the source `.drawio` file in the same directory with exported SVG to allow future edits.

## License

License: CC BY-NC-SA 4.0

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

Pandoc/LaTeX template [Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template/) is licensed by BSD 3-Clause License.
