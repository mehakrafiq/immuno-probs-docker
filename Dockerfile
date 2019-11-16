# Fetch latest ubuntu image for the ImmunoProbs image build.
FROM ubuntu:latest

# Install some apt linux packages.
RUN apt-get update \
    && apt-get install -y \
        gcc-7 \
        g++-7 \
        muscle \
        python-pip \
        unzip \
        wget

# Download a version of IGoR, unpack it and compile.
RUN mkdir -p /usr/src \
    && wget -c https://github.com/qmarcou/IGoR/releases/download/1.3.0/igor_1-3-0.zip -O igor.zip \
    && unzip igor.zip -d /usr/src \
    && rm igor.zip
WORKDIR /usr/src/igor_1-3-0
RUN ./configure CC=gcc-7 CXX=g++-7 \
    && make \
    && make install

# Copy and unpack the tutorial data files.
WORKDIR /
COPY tutorial_data.zip /
RUN mkdir -p /tutorial_data \
    && unzip tutorial_data.zip -d /tutorial_data \
    && rm tutorial_data.zip

# Install given version of ImmunoProbs.
ARG VERSION
RUN pip install immuno-probs==$VERSION

# Specify default setting to be the ImmunoProbs docker image execution.
WORKDIR /tmp/
COPY docker_entrypoint.sh /usr/src
ENTRYPOINT ["/usr/src/docker_entrypoint.sh"]
CMD ["immuno-probs"]
