FROM ubuntu:20.04

WORKDIR /root

# Set noninteractive for tzdata
ENV DEBIAN_FRONTEND=noninteractive

# SOFTWARE PACKAGES
#   * git
#   * python3
#   * python3-pip
#   * r-base
#   * nodejs
#   * npm
#   * curl 
#   * libgdal-dev: needed to install R packages
#   * libcurl4-openssl-dev: needed to install R packages
#   * libxml2-dev: needed to install R packages
#   * libudunits2-dev: needed to install R packages
ENV PACKAGES="\
  git \
  python3 \
  python3-pip \
  r-base \
  nodejs \
  npm \
  curl \
  libgdal-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  libudunits2-dev \
"

# PYTHON DATA SCIENCE PACKAGES
#   * numpy: support for large, multi-dimensional arrays and matrices
#   * matplotlib: plotting library for Python and its numerical mathematics extension NumPy.
#   * scipy: library used for scientific computing and technical computing
#   * scikit-learn: machine learning library integrates with NumPy and SciPy
#   * pandas: library providing high-performance, easy-to-use data structures and data analysis tools
#   * nltk: suite of libraries and programs for symbolic and statistical natural language processing for English
#   * csvkit: suite of tools for CSV manipulation
ENV PYTHON_PACKAGES="\
  numpy \
  matplotlib \
  scipy \
  scikit-learn \
  pandas \
  nltk \
  csvkit \
" 

# NODE PACKAGES
#   * mapshaper: tools for processing GeoJSON
#   * shapefile: tools for manipulating shapefiles
#   * d3-geo-projection: includes geo2svg for creating svg from geojson
#   * ndjson-cli: tools for processing json
ENV NODE_PACKAGES="\
  mapshaper \
  shapefile \
  d3-geo-projection \
  ndjson-cli \
"

RUN apt-get update

# INSTALL ALL PACKAGES
RUN apt-get install -y $PACKAGES \
  && pip3 install --no-cache-dir $PYTHON_PACKAGES \
  && npm i -g $NODE_PACKAGES \
  && R -e 'install.packages(c("tidyverse", "tidycensus", "sf", "tigris"))'

# INSTALL TIPPECANOE
RUN git clone https://github.com/mapbox/tippecanoe.git \
  && cd tippecanoe \
  && make -j \
  && make install

CMD ["/bin/bash"]