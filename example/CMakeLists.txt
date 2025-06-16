cmake_minimum_required(VERSION 3.5)
project(example)

# add executable file
add_executable(main main.cpp)

# enable ctest
enable_testing()

# add a simple test, if main executes successfully 
# and return 0 code, then pass the test
add_test(NAME TestMain COMMAND main)
