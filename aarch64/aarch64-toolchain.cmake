set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_CROSSCOMPILING TRUE)

set(TRIPLE aarch64-linux-gnu)

# Find the C and C++ cross-compilers
find_program(CMAKE_C_COMPILER NAMES ${TRIPLE}-gcc)
find_program(CMAKE_CXX_COMPILER NAMES ${TRIPLE}-g++)

if(NOT CMAKE_C_COMPILER)
    message(FATAL_ERROR "AArch64 C compiler (${TRIPLE}-gcc) not found!")
endif()
if(NOT CMAKE_CXX_COMPILER)
    message(FATAL_ERROR "AArch64 CXX compiler (${TRIPLE}-g++) not found!")
endif()

# Set the sysroot for finding target libraries and headers
set(CMAKE_FIND_ROOT_PATH "/usr/${TRIPLE}")

# Configure how CMake searches for programs, libraries, and includes
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
