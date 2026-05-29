FROM docker.io/library/golang:1.19.3-bullseye@sha256:34e901ebac66df44ce97b56a9e1bb407307e54fe13e843d6c59da7826ce4dd2c as builder
COPY . /go/src
WORKDIR /go/src
RUN CGO_ENABLED=0 go build .

# Runtime
# -------

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /go/src/tfe_exporter /
ENTRYPOINT ["/tfe_exporter"]