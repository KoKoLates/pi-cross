# Raspberry Pi Cross-Compilation
This repository offers a set of powerful Docker images designed for seamless Raspberry Pi cross-compilation. These images (`kokolates/pi-cross:armv7` and `kokolates/pi-cross:aarch64`) come pre-loaded with essential development tools, including build-essential, cmake, git, and the necessary GNU cross-toolchains. A core feature of this setup is the `cross` script. This intuitive wrapper simplifies executing commands within the Docker container, providing a user experience similar to popular tools like [`dockcross`](https://github.com/dockcross/dockcross).


## Features
- **Lightweight Base**: Built on `debian:stable-slim` to ensure a minimal footprint.
- **Complete Toolchains**: Includes `gcc`, `g++`, and `libc6` for both `ARMv7 (armhf)` and `ARMv8 (aarch64)` architectures, covering a wide range of Raspberry Pi models.
- **Pre-configured CMake**: The `CMAKE_TOOLCHAIN_FILE` is automatically set, making your cmake projects ready for cross-compilation with minimal setup.

## Raspberry Pi & Compiler Compatibility
Choosing the right Docker image depends on your target Raspberry Pi model and the operating system you're running on it. Refer to the table below to determine which compiler image best suits your needs

| Raspberry Pi Model(s)| Recommended OS | Architecture | Images |
| -- | -- | -- | -- |
| 2B, 3B, 3B+ | RPi OS Lite (32-bit) | ARMv7 | `kokolates/pi-cross:armv7` |
| 3B, 3B+, 4B | RPi OS Lite (64-bit) / Ubuntu | ARMv8 | `kokolates/pi-cross:aarch64` |

## Getting Started
Let's use the `armv7` image as an example. The process is identical for `aarch64`. The quickest way is to pull the pre-built image directly from DockerHub. Choose the image appropriate for your target architecture:

```bash
docker pull kokolates/pi-cross:armv7
```

If you prefer to build the image from source or want to customize the `Dockerfile`, `toolchain.cmake`, or `entrypoint.sh`, start by cloning the repository:

```bash
git clone https://github.com/KoKoLates/pi-cross.git
cd pi-cross
```

Then, navigate into the appropriate architecture directory (`armv7` or `aarch64`) and build the image:

```bash
docker build -t kokolates/pi-cross:armv7 armv7/
```

Once you have the Docker image, you can generate the `cross` script in your current directory. Ensure you use the specific Docker image you intend to use for cross-compilation.

```bash
docker run --rm kokolates/pi-cross:armv7 > cross
```

Next, make the script executable:

```
chmod +x cross
```

You now have a `cross` script ready to execute commands within your chosen cross-compilation environment. If you need to switch between `armv7` and `aarch64`, simply re-generate the cross script using the other image or use different file name for different script.

## Usage

The `cross` script acts as a seamless wrapper. It automatically mounts your current host project directory into `/work` inside the container and sets it as the working directory, making your local files accessible. Before you start, it's a good idea to confirm that the correct cross-compilers and toolchain file are set:

```bash
./cross printenv CC CXX CMAKE_TOOLCHAIN_FILE
```

If the output correctly displays compilers like `arm-linux-gnueabihf-gcc`, `arm-linux-gnueabihf-g++`, and the appropriate `CMAKE_TOOLCHAIN_FILE`, you're all set!

You can now use the `cross` script to configure and build your projects just as you would with native `cmake` and `make`. This repository includes an `example/` C++ program with its cmake configuration, which displays system and architecture information. To configure a project where your `CMakeLists.txt` is in the `example/` directory and you want to create a `build/` directory:

```bash
./cross cmake -S example -B example/build/
```

To build the configured cmake project

```bash
./cross cmake --build example/build/
```

If your project uses make directly (e.g., after cmake generation or for a non-cmake project)

```bash
./cross make -C build
```

You can drop into a bash shell inside the container for debugging or manual operations with `bash` command to start a interactive mode, or pass command with options to `cross` which will be executed within the selected cross-compilation environment inside the Docker container 

```bash
./cross bash                      # Enter interative shell
./cross bash -c "touch test.cpp"  # Create a new file
```

For a quick reference on the `cross` script's usage, including available options:

```bash
./cross --help
```
