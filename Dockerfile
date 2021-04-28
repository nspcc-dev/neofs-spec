FROM ubuntu:20.04
MAINTAINER Stanislav Bogatyrev <stanislav@nspcc.ru>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y \
  git \
  graphviz \
  imagemagick \
  latexmk \
  libgraphviz-dev \
  make \
  openjdk-14-jre \
  python3-pip \
  librsvg2-bin \
  texlive-fonts-extra \
  texlive-fonts-recommended \
  texlive-latex-base \
  texlive-latex-extra \
  texlive-latex-recommended \
  texlive-xetex \
  wget && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/*

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
# I know about requirements.txt, but it didn't work as expected
RUN pip3 install panflute==1.12.5
RUN pip3 install pandoc-img-glob==0.1.3
RUN pip3 install pandoc-plantuml-filter==0.1.2
RUN pip3 install pandocfilters==1.4.2

# Cleanup
RUN rm -rf /tmp/*

WORKDIR /src
CMD /bin/bash
