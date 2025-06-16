# Dockerfile for pi-cross:armv7
# This Dockerfile builds a custom image designed for ARMv7 cross-compilation.
# It includes the necessary toolchains and pre-configures CMake to target ARMv7,
# making the cross-compilation process seamless.

FROM debian:stable-slim
# Using 'debian:stable-slim' provides a lightweight and stable Debian base,
# which is good for keeping the final image size down while offering a robust environment.

# Environment Variables (Build-time and Runtime)
ENV DEBIAN_FRONTEND=noninteractive
# This environment variable prevents debconf from prompting for user input during apt-get operations.
# It's essential for automated builds in CI/CD pipelines where no user interaction is possible.

# Install Core Tools and Cross-Compilation Toolchain
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
# 'apt-get update': Fetches the list of available packages and their versions.
# 'apt-get install -y --no-install-recommends': Installs packages non-interactively without pulling in optional dependencies.
#   - build-essential: Provides core build tools like make, dpkg-dev, and essential libraries.
#   - cmake: A cross-platform build system generator.
#   - git, wget, curl: Common utilities for source control, downloading files, and network requests.
#   - gcc-arm-linux-gnueabihf: The GNU C cross-compiler for ARMv7 (hard float ABI). This is your main cross-compiler.
#   - g++-arm-linux-gnueabihf: The GNU C++ cross-compiler for ARMv7.
#   - libc6-armhf-cross: The GNU C Library (libc) specifically compiled for the ARMv7 hard float target.

# Cleanup APT Cache
RUN apt-get clean
# Cleans up the APT cache, removing downloaded package files (.deb) after installation.
# This helps reduce the final Docker image size.
RUN rm -rf /var/lib/apt/lists/*
# Removes the list of available packages, further reducing image size.

# Configure Cross-Compiler Environment Variables
ENV CC=arm-linux-gnueabihf-gcc \
    CXX=arm-linux-gnueabihf-g++ \
    AR=arm-linux-gnueabihf-ar \
    RANLIB=arm-linux-gnueabihf-ranlib
# These environment variables (CC, CXX, AR, RANLIB) are standard and recognized by
# many build systems (including Make and CMake) to specify which compilers and
# archiving tools should be used. By setting them to the ARM cross-toolchain binaries,
# you ensure that `make` and `cmake` (when configured correctly)
# will default to cross-compiling for ARMv7.

# Copy and Configure CMake Toolchain File
# This step brings in a pre-defined CMake toolchain file from your host machine.
# This file explicitly tells CMake how to find and use the ARMv7 cross-compiler
# and its associated libraries/headers.
COPY armv7-toolchain.cmake /opt/armv7-toolchain.cmake
# 'COPY armv7-toolchain.cmake /opt/armv7-toolchain.cmake': Copies the CMake toolchain file
# from the build context (where your Dockerfile is located) into the container
# at '/opt/armv7-toolchain.cmake'.

# Set CMAKE_TOOLCHAIN_FILE environment variable for CMake to pick it up by default
ENV CMAKE_TOOLCHAIN_FILE=/opt/armv7-toolchain.cmake
# This environment variable instructs CMake to automatically load the specified
# toolchain file ('/opt/armv7-toolchain.cmake') for all build configurations.
# This makes CMake automatically use the ARMv7 cross-compiler without needing to
# specify '-DCMAKE_TOOLCHAIN_FILE' on the command line.

# This is your custom entrypoint script that acts as the "smart" wrapper
# for the Docker image (like 'dockcross'). It handles generating the host helper script
# or executing commands within the cross-compilation environment.
COPY entrypoint.sh /usr/local/bin/armv7-cross
# 'COPY entrypoint.sh /usr/local/bin/armv7-cross': Copies your entrypoint script
# from the build context into the container.

RUN chmod +x /usr/local/bin/armv7-cross
# Makes the copied entrypoint script executable. Without this, the script couldn't be run.

# Define Container Entrypoint and Default Command
ENTRYPOINT ["/usr/local/bin/armv7-cross"]
# Sets the main command that will be executed when the container starts.
# Any arguments passed to 'docker run' will be appended to this entrypoint.
# Your 'armv7-cross' script then intelligently decides what to do based on these arguments.

CMD []
# Specifies the default command that will be passed as arguments to the ENTRYPOINT
# if no other arguments are provided to 'docker run'.
# Setting it to an empty array ('[]') is crucial here. It ensures that when you run
# `docker run --rm <image>`, no default command is passed, making the entrypoint script's
# `$#` (number of arguments) equal to 0. This correctly triggers the helper script generation mode.
