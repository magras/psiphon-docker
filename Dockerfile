ARG GOVERSION=1.22.4
FROM docker.io/library/golang:$GOVERSION AS builder
WORKDIR /usr/local/src/psiphon-tunnel-core
COPY psiphon-tunnel-core .
ARG BUILDDATE
ARG BUILDREPO
ARG BUILDREV
ARG GOVERSION
RUN CGO_ENABLED=0 go install -ldflags "\
    -X github.com/Psiphon-Labs/psiphon-tunnel-core/psiphon/common/buildinfo.buildDate=$BUILDDATE \
    -X github.com/Psiphon-Labs/psiphon-tunnel-core/psiphon/common/buildinfo.buildRepo=$BUILDREPO \
    -X github.com/Psiphon-Labs/psiphon-tunnel-core/psiphon/common/buildinfo.buildRev=$BUILDREV \
    -X github.com/Psiphon-Labs/psiphon-tunnel-core/psiphon/common/buildinfo.goVersion=$GOVERSION \
    " ./ConsoleClient
RUN mkdir /var/lib/psiphon

FROM scratch
ARG UID=1000
ARG GID=1000
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/bin/ConsoleClient /psiphon-tunnel-core
COPY --from=builder --chown=$UID:$GID /var/lib/psiphon /var/lib/psiphon
USER $UID:$GID
ENTRYPOINT ["/psiphon-tunnel-core"]
