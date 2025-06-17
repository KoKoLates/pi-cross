FROM debian:stable-slim
# Using 'debian:stable-slim' provides a lightweight and stable Debian base,
# which is good for keeping the final image size down while offering a robust environment.

# Environment Variables (Build-time and Runtime)
ENV DEBIAN_FRONTEND=noninteractive

# Install Core Tools and Cross-Compilation Toolchain
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    libc6-dev-arm64-cross
# 'apt-get update': Fetches the list of available packages and their versions.
# 'apt-get install -y --no-install-recommends': Installs packages non-interactively without pulling in optional dependencies.
#   - build-essential: Provides core build tools like make, dpkg-dev, and essential libraries.
#   - cmake: A cross-platform build system generator.
#   - git, wget, curl: Common utilities for source control, downloading files, and network requests.
#   - gcc-aarch64-linux-gnu: The GNU C cross-compiler for AArch64. This is your main cross-compiler.
#   - g++-aarch64-linux-gnu: The GNU C++ cross-compiler for AArch64.
#   - libc6-dev-arm64-cross: The GNU C Library (libc) development files specifically compiled for the AArch64 target.

# Cleanup APT Cache
RUN apt-get clean
# Cleans up the APT cache, removing downloaded package files (.deb) after installation.
# This helps reduce the final Docker image size.
RUN rm -rf /var/lib/apt/lists/*
# Removes the list of available packages, further reducing image size.

# Configure Cross-Compiler Environment Variables
ENV CC=aarch64-linux-gnu-gcc \
    CXX=aarch64-linux-gnu-g++ \
    AR=aarch64-linux-gnu-ar \
    RANLIB=aarch64-linux-gnu-ranlib
# These environment variables (CC, CXX, AR, RANLIB) are standard and recognized by
# many build systems (including Make and CMake) to specify which compilers and
# archiving tools should be used. By setting them to the AArch64 cross-toolchain binaries,
# you ensure that `make` and `cmake` (when configured correctly)
# will default to cross-compiling for AArch64.

# Copy and Configure CMake Toolchain File
COPY aarch64-toolchain.cmake /opt/aarch64-toolchain.cmake

# Set CMAKE_TOOLCHAIN_FILE
ENV CMAKE_TOOLCHAIN_FILE=/opt/aarch64-toolchain.cmake
# This environment variable instructs CMake to automatically load the specified
# toolchain file ('/opt/aarch64-toolchain.cmake') for all build configurations.

# This is your custom entrypoint script that acts as the "smart" wrapper
# for the Docker image (like 'dockcross'). It handles generating the host helper script
# or executing commands within the cross-compilation environment.
COPY entrypoint.sh /usr/local/bin/aarch64-cross
# 'COPY entrypoint.sh /usr/local/bin/aarch64-cross': Copies your entrypoint script
# from the build context into the container.

RUN chmod +x /usr/local/bin/aarch64-cross
# Makes the copied entrypoint script executable. Without this, the script couldn't be run.

# Define Container Entrypoint and Default Command
ENTRYPOINT ["/usr/local/bin/aarch64-cross"]
# Sets the main command that will be executed when the container starts.
# Any arguments passed to 'docker run' will be appended to this entrypoint.
# Your 'aarch64-cross' script then intelligently decides what to do based on these arguments.

CMD []
