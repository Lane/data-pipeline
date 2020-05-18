FROM ubuntu:20.04

WORKDIR /root

# Set noninteractive for tzdata
ENV DEBIAN_FRONTEND=noninteractive  

# ############# (adds ~380MB)
# BASE SETUP
#   * git
#   * wget
#   * curl
#   * unzip 
ENV BASE_PACKAGES="\
  git \
  curl \
  wget \
  gzip \
  unzip \
  build-essential \
  libsqlite3-dev \
  zlib1g-dev \
  libssl-dev \
  libspatialindex-dev \
  locales \
"
RUN apt-get update \
  && apt-get install -y $BASE_PACKAGES
# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
# #############


# #############
# INSTALL R (adds ~1GB to image 😬)
#   * r-base
#   * libgdal-dev: needed to install R packages
#   * libcurl4-openssl-dev: needed to install R packages
#   * libxml2-dev: needed to install R packages
#   * libudunits2-dev: needed to install R packages
ENV R_APT_PACKAGES="\
  r-base \
  libgdal-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  libudunits2-dev \
"
# Packages:
#   * tidyverse
#   * tidycensus
#   * sf
#   * tigris
ENV R_PACKAGES='"tidyverse", "tidycensus", "sf", "tigris"'
RUN apt-get install -y $R_APT_PACKAGES \
  && R -e 'install.packages(c('"$R_PACKAGES"'))'
# #############


# #############
# INSTALL PYTHON
#   * python3
#   * python3-pip
ENV PYTHON_APT_PACKAGES="\
  python3-dev \
  python3-pip \
"
# Packages:
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
  boto3 \
  census \
  census_area \
  geopandas \
  Rtree \
  awscli \
"
RUN apt-get install -y $PYTHON_APT_PACKAGES \
  && pip3 install --no-cache-dir $PYTHON_PACKAGES
# #############

# #############
# INSTALL NODE
#   * nodejs
#   * npm
ENV NODE_APT_PACKAGES="\
  nodejs \
  npm \
"
# Packages:
#   * mapshaper: tools for processing GeoJSON
#   * shapefile: tools for manipulating shapefiles
#   * d3-geo-projection: includes geo2svg for creating svg from geojson
#   * ndjson-cli: Unix-y tools for operating on newline-delimited JSON streams.
ENV NODE_PACKAGES="\
  mapshaper \
  shapefile \
  d3-geo-projection \
  ndjson-cli \
"
RUN apt-get install -y $NODE_APT_PACKAGES \
  && npm i -g $NODE_PACKAGES
# #############

# #############
# INSTALL TIPPECANOE
#   * For generating vector map tiles from data
RUN git clone https://github.com/mapbox/tippecanoe.git \
  && cd tippecanoe \
  && make -j \
  && make install
# #############
