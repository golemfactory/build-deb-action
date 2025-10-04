FROM docker.io/rust:1.90.0-bullseye

RUN cargo install cargo-deb

# We need newer version of cmake, than in default repository
ADD https://github.com/Kitware/CMake/releases/download/v4.1.2/cmake-4.1.2-linux-x86_64.sh /cmake-4.1.2.sh
RUN mkdir /opt/cmake
RUN sh /cmake-4.1.2.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

