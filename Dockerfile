FROM ubuntu:20.04
MAINTAINER Stanislav Bogatyrev <stanislav@nspcc.ru>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y \
  git \
  make \
  graphviz \
  libgraphviz-dev \
  imagemagick \
  python3-pip \
  texlive-fonts-extra \
  texlive-fonts-recommended \
  texlive-latex-base \
  texlive-latex-extra \
  texlive-latex-recommended \
  texlive-xetex \
  openjdk-14-jre \
  wget

# Install pandoc
RUN cd /tmp && \
  wget -q https://github.com/jgm/pandoc/releases/download/2.9.2.1/pandoc-2.9.2.1-1-amd64.deb && \
  dpkg -i pandoc-2.9.2.1-1-amd64.deb

# Install pandoc-crossref
RUN cd /tmp && \
  wget -q https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.6.4/pandoc-crossref-Linux-2.9.2.1.tar.xz && \
  tar -Jxvf pandoc-crossref-Linux-2.9.2.1.tar.xz && mv pandoc-crossref /usr/bin/

# Install PlantUML
ENV PLANTUML_BIN java -jar /usr/bin/plantuml.jar
RUN wget -q http://downloads.sourceforge.net/project/plantuml/1.2020.15/plantuml.1.2020.15.jar -O /usr/bin/plantuml.jar

# Install python stuff
RUN pip3 install pandocfilters
RUN pip3 install pyyaml
RUN pip3 install pandoc-plantuml-filter

WORKDIR /src
CMD /bin/bash
