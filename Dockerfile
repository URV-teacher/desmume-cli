FROM ubuntu:24.04 AS build

# Required packages
RUN apt-get update && apt-get install -y \
    build-essential  \
    gcc \
    make \
    ninja-build \
    git \
    cmake \
    libsdl2-dev \
    libpcap-dev \
    libgtk-3-dev \
    libopenal-dev \
    libsoundtouch-dev \
    libagg-dev \
    libosmesa6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#     git checkout 7c7fd242c221a8f722d39f9df5cdf40789cb31e3 && \
# Clone and build DeSmuME CLI
RUN git clone https://github.com/TASEmulators/desmume /desmume && \
    cd /desmume/desmume/src/frontend/posix && \
    meson build -Dfrontend-cli=true -Dgdb-stub --buildtype=release && \
    mkdir -p /desmume/desmume/src/frontend/posix/build && \
    ninja -C /desmume/desmume/src/frontend/posix/build

FROM ubuntu:24.04 AS runtime

# Required packages
RUN apt-get update && apt-get install -y \
    libsdl2-dev \
    libpcap-dev \
    libgtk-3-dev \
    libopenal-dev \
    libsoundtouch-dev \
    libagg-dev \
    libosmesa6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
COPY --from=build /desmume/desmume/src/frontend/posix/build/* /usr/local/bin