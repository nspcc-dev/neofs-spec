# NeoFS Technical Specification

## Document format

This document uses a mix of Markdown and LaTeX in [pandoc](https://pandoc.org/) flavors.

## Build instructions (manual build)

Install pandoc and LaTeX base. Please see Dockerfile for the detailed list of
what you might need.

After pandoc and LaTeX base are available, you can simply run `make`, which will
generate the specification paper pdf.

## Build using docker
The easiest way to build is by using docker.

* Compile the specification paper using `make docker_build`
* Output will be generated as `output/neofs-spec-<revision>.pdf`

You can build docker image locally with `make docker_image`

## How to contribute
If you know NeoFS technology and want to contribute, feel free to directly
submit a Pull Request with the desired changes.

Initially, the idea is to create a broad and complete initial version of the
document, which will be polished in the future.

## License

License: CC BY-NC-SA 4.0

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img
alt="Creative Commons License" style="border-width:0"
src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This
work is licensed under a <a rel="license"
href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons
Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

Pandoc/LaTeX template
[Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template/) is licensed
by BSD 3-Clause License.
