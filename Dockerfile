# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git clang cmake

ADD . /vedis
WORKDIR /vedis

## Build
RUN clang -fsanitize=fuzzer vedis.c fuzz/fuzz_vedis_exec.c -I . -o vedis-fuzz

## Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /vedis/vedis-fuzz /vedis-fuzz
