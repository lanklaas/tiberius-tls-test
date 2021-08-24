FROM rust:1.53.0-alpine3.12 as builder
RUN apk add alpine-sdk
RUN apk add libressl-dev
# To avoid segfault cause we dont install openssl in the end
ENV OPENSSL_DIR=/usr
ENV OPENSSL_STATIC=1
WORKDIR app
COPY . .

RUN cargo b --release

FROM alpine:latest
WORKDIR /appdir
# Copy exe
COPY --from=builder /app/target/release/tiberius-tls ./

CMD ["/appdir/tiberius-tls"]