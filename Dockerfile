# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git clang cmake

## Add source code to the build stage. ADD prevents git clone being cached when it shouldn't
WORKDIR /
ADD https://api.github.com/repos/capuanob/vedis/git/refs/heads/mayhem version.json
RUN git clone -b mayhem https://github.com/capuanob/vedis.git
WORKDIR /vedis

## Build
RUN mkdir -p build
WORKDIR build
RUN cmake .. -DCMAKE_C_COMPILER=clang

## Prepare all library dependencies for copy
RUN mkdir /deps
RUN cp `ldd ./fuzz/vedis-fuzz | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :

## Package Stage

FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /vedis/fuzz/vedis-fuzz /vedis-fuzz
COPY --from=builder /deps /usr/lib
COPY --from=builder /gregorio/corpus /tests

CMD "/vedis-fuzz -close_fd_mask=2"
