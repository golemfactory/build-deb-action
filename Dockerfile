FROM docker.io/rust:1.71.1-buster

RUN cargo install cargo-deb

# We need newer version of cmake, than in default repository
ADD https://cmake.org/files/v3.23/cmake-3.23.2-linux-x86_64.sh /cmake-3.23.2-linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.23.2-linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

