# Dockerfile for armv7-cross
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools and cross-compilation toolchain
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    libc6-armhf-cross

RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/*

# Configure environment variables
ENV CC=arm-linux-gnueabihf-gcc \
    CXX=arm-linux-gnueabihf-g++ \
    AR=arm-linux-gnueabihf-ar \
    RANLIB=arm-linux-gnueabihf-ranlib

# Copy the pre-defined CMake toolchain file into the container
COPY armv7-toolchain.cmake /opt/armv7-toolchain.cmake

# Set CMAKE_TOOLCHAIN_FILE environment variable for CMake to pick it up by default
ENV CMAKE_TOOLCHAIN_FILE=/opt/armv7-toolchain.cmake

COPY entrypoint.sh /usr/local/bin/armv7-cross
RUN chmod +x /usr/local/bin/armv7-cross

ENTRYPOINT ["/usr/local/bin/armv7-cross"]
CMD []
