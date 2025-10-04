FROM docker.io/rust:1.90.0-bullseye

RUN cargo install cargo-deb

# We need newer version of cmake, than in default repository
ADD https://cmake.org/files/v3.31/cmake-3.31.9-linux-x86_64.sh /cmake-3.31.9.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.31.9.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

