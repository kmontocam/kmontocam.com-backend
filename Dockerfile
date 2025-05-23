FROM rust:1.82-bookworm AS plan
WORKDIR /tmp
RUN cargo install cargo-chef
COPY Cargo.toml Cargo.lock ./
COPY src src
RUN cargo chef prepare --recipe-path recipe.json


FROM rust:1.82-bookworm AS cache
WORKDIR /tmp
RUN cargo install cargo-chef
COPY --from=plan /tmp/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json


FROM rust:1.82-bookworm AS builder
ENV SQLX_OFFLINE=true
WORKDIR /tmp
COPY Cargo.toml Cargo.lock ./
COPY build.rs build.rs
COPY migrations migrations
# NOTE: dir needs to exist locally, run `cargo sqlx prepare` with database service up
COPY .sqlx .sqlx
COPY src src
COPY --from=cache /tmp/target target
COPY --from=cache /usr/local/cargo /usr/local/cargo
RUN cargo build --release


FROM debian:bookworm
WORKDIR /opt/
RUN apt update
RUN apt install -y libssl-dev ca-certificates
COPY migrations migrations
COPY templates templates
COPY --from=builder /tmp/target/release/kmontocam-backend .
EXPOSE 3000
CMD ["/opt/kmontocam-backend"]
