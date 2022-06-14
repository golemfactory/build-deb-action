FROM prekucki/ya-build-deb
RUN apt-get update && apt-get install -y \
    cmake \
    autoconf automake libtool curl make g++ unzip \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

