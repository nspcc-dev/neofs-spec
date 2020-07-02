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

* Build the docker image using `make docker_image`
* Compile the specification paper using `make docker_build`
* Output will be generated as `output/neofs-spec-<revision>.pdf`

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

A summary of this license is as follows.

You are free to:

Share — copy and redistribute the material in any medium or format

Adapt — remix, transform, and build upon the material

The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

NonCommercial — You may not use the material for commercial purposes.

ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

Pandoc/LaTeX template
[Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template/) is licensed
by BSD 3-Clause License.
