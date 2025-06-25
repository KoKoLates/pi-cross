#!/bin/bash
set -e 

IMAGE_NAME="kokolates/pi-cross:armv7"
CONTAINER_WORK_DIR="/work"

generate_script() {
    cat << EOF
#!/bin/bash
# This script is a wrapper that executes commands within the '$IMAGE_NAME' Docker
# image for ARMv7 cross-compilation.

# Check if Docker is available on the host system.
if ! command -v docker &> /dev/null
then
    echo "Error: Docker command not found. Please install Docker." >&2
    exit 1
fi

# The helper function for the host script's 'usage' display
usage() {
    cat << EOT_HELP
Usage:
  ./cross <your_command_or_option>

Options:
  --help    Display the help message and exit

Examples:
  ./cross cmake -S . -B build       # Configure CMake project with CMakeLists.txt in 
                                    # current foler (project root) and indicate build folder
  ./cross cmake --build build       # Build the project with configuration of CMake
  ./cross make -C build             # Compile the project with Make
  ./cross bash                      # Enter a shell inside the container

It automatically mounts the current host's project directory into $CONTAINER_WORK_DIR
inside the container and sets $CONTAINER_WORK_DIR as the working directory.
EOT_HELP
}

if [[ "\$1" == "--help" ]]; then
    usage
    exit 0
elif [[ "\$#" -eq 0 ]]; then
    echo "Error: You need to provide a command to execute." >&2
    usage >&2
    exit 1
fi

INTERACTIVE_FLAGS=""
case "\$1" in
    bash|sh|zsh|/bin/bash|/bin/sh|/bin/zsh)
        INTERACTIVE_FLAGS="-it"
        ;;
    *)
        ;;
esac

# Execute the core Docker command with image's entrypoint
docker run --rm \$INTERACTIVE_FLAGS -v \$(pwd):$CONTAINER_WORK_DIR -w $CONTAINER_WORK_DIR $IMAGE_NAME "\$@"
EOF
}

execute_command() {
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    exec "$@"
}

# Main logic flow of entrypoint.sh. This script decides whether to:
# 1. Generate the helper script, when running without arguments from host
# 2. Execute a command inside the container, running via helper script
# 3. Show the internal help.
if [[ $# -eq 0 ]]; then
    generate_script
    exit 0
else 
    execute_command "$@"
fi
