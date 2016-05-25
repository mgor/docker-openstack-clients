FROM ubuntu:latest
MAINTAINER Mikael Göransson <github@mgor.se>

RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y \
        curl \
        netcat-openbsd \
        git \
        openssh-client \
        python-pip \
        python-ceilometerclient \
        python-cinderclient \
        python-glanceclient \
        python-heatclient \
        python-keystoneclient \
        python-neutronclient \
        python-novaclient \
        python-swiftclient \
        python-troveclient && \
        pip install --upgrade pip

# Build urllib3 from source
RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    git clone https://github.com/shazow/urllib3.git && \
    cd urllib3 && \
    export VERSION="$(git describe --tags  $(git rev-list --tags --max-count=1) | awk -F\. '{print $1"."$2"."($3+1)}')" && \
    sed -i -r "s|(__version__).*|\1 = '${VERSION}'|" urllib3/__init__.py && \
    make clean && \
    python setup.py sdist && \
    pip install dist/urllib3-${VERSION}.tar.gz[socks] && \
    cd / && rm -rf /tmp/build

RUN apt-get -y purge \
    git \
    python-pip && \
    apt-get -y autoremove \
    # Clean up!
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
