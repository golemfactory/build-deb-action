FROM ubuntu:16.04
WORKDIR /src/
RUN apt-get update && apt-get install -y curl gcc pkg-config libssl-dev git
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cargo-deb

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

