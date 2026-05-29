FROM docker.io/library/golang:1.26.3-bookworm AS webappbuilder
COPY ./webapp /go/src
WORKDIR /go/src
RUN CGO_ENABLED=0 go build .

FROM docker.io/library/golang:1.26.3-bookworm AS autodeploybuilder
COPY ./autodeploy /go/src
WORKDIR /go/src
RUN CGO_ENABLED=0 go build .

# Runtime
# -------

FROM docker.io/library/golang:1.26.3-bookworm
COPY --from=webappbuilder /go/src/webapp /
COPY --from=autodeploybuilder /go/src/autodeploy /
RUN ls -la ./*