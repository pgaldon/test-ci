FROM docker.io/library/golang:1.26.3-bookworm AS builder
COPY . /go/src
WORKDIR /go/src
RUN CGO_ENABLED=0 go build .
RUN ls -la

# Runtime
# -------

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /go/src/test-ci /
ENTRYPOINT ["/test-ci"]