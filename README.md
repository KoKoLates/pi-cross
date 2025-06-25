# Raspberry Pi Cross-Compilation
This repository provides Docker images specifically designed for Raspberry Pi cross-compilation. They bundle essential tools like `build-essential`, `cmake`, `git`, and the necessary GNU cross-toolchains. A key feature of this setup is the provided `cross` helper script, which simplifies the process of executing commands within the Docker container, mirroring the functionality of [`dockcross`](https://github.com/dockcross/dockcross).


## Features
- **Lightweight Base**: Built on `debian:stable-slim` for a minimal footprint.
- **Complete Toolchains**: Includes `gcc`, `g++`, and `libc6` for both `ARMv7 (armhf)` and `ARMv8 (aarch64)` targets.
- **Pre-configured CMake**: `CMAKE_TOOLCHAIN_FILE` is automatically set to `/opt/<arch>-toolchain.cmake`, making CMake projects out-of-the-box ready for cross-compilation.

## Raspberry Pi & Compiler Compatibility
Choosing the correct compiler (and thus Docker image) depends on your specific Raspberry Pi model and the operating system you're targeting.

| Raspberry Pi Model(s)| Recommended OS | Architecture | Images |
| -- | -- | -- | -- |
| Raspberry Pi 2B, 3B, 3B+ | Raspberry Pi OS Lite (32-bit) | ARMv7 | `kokolates/pi-cross:armv7` |
| Raspberry Pi 3B, 3B+, 4B | Raspberry Pi OS Lite (64-bit) / Ubuntu | ARMv8 | `kokolates/pi-cross:aarch64` |

## Getting Started
Take `armv7` image as example. There are pre-built image on DockerHub, user could pull corresponding image appropriate for their target architecture directly

```bash
docker pull kokolates/pi-cross:armv7
```

If preferring to build image locally or want to modify `Dockerfile`, `toolchain.cmake`, or `entrypoint.sh`, then you can pull the repository from Github and build locally:

```bash
git clone https://github.com/KoKoLates/pi-cross.git
cd pi-cross

# Build the image with Dockerfile
docker build -t kokolates/pi-cross:armv7 armv7
```
Once you have the Docker image, generate the `cross` script in your current directory. Make sure to use the specific image you intend to use for cross-compilation.

```bash
docker run --rm kokolates/pi-cross:armv7 > cross

# Make the script executable
chmod +x cross
```
Now you have a `cross` script that you can use to run commands within the chosen cross-compilation environment.

## Usage
The `cross` script acts as a convenient wrapper for your Docker container, automatically mounting your current host project directory into `/work` inside the container and setting it as the working directory. You can verify that the correct cross-compilers and toolchain file are set by running:

```bash
./cross printenv CC CXX CMAKE_TOOLCHAIN_FILE
```

If the cross-compiler `arm-linux-gnueabihf-gcc`, `arm-linux-gnueabihf-g++` show up correctly, then you could use the `cross` script to configure and build as normal as what you use `cmake` and `make`. In my repository, there are an example of c++ program with corresponding cmake configuration, which the program just show some system and architecture informations. To configure a project where your `CMakeLists.txt` is in the `example` directory and you want to build in `example/build/`

```bash
./cross cmake -S example -B example/build/
```

To build the configured CMake project

```bash
./cross cmake --build example/build/
```

If your project uses Make directly (e.g., after cmake generation or for a non-cmake project)

```bash
./cross make -C build
```

To drop into a bash shell inside the container for debugging or manual operations. Any command you pass to `cross` will be executed within the selected cross-compilation environment inside the Docker container

```bash
./cross bash                      # enter interative bash
./cross bash -c "touch test.cpp"  # create a new file
```

For a quick reference on the `cross` script's usage

```bash
./cross --help
```
