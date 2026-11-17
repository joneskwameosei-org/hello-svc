# Build a static binary, then copy it into a distroless image: no shell, no package manager, runs as UID 65532.
# Base images pinned by digest (the tag is for people; the digest is what's pulled).
FROM golang:1.27.4-alpine@sha256:70bd7ddea8b6cbe5d6943cde279d6b67feb10cc924fb9100d1d8757c1575b280 AS build
WORKDIR /src
COPY go.mod ./
COPY *.go ./
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/hello-svc .

FROM gcr.io/distroless/static-debian13:nonroot@sha256:aafe993665bf6200db38a02c11a9351e782a84b6a45e7f33b6695638c88e3931
COPY --from=build /out/hello-svc /hello-svc
USER 65532:65532
EXPOSE 8080
ENTRYPOINT ["/hello-svc"]
