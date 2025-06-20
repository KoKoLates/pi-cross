#include <string>
#include <iostream>
#include <sys/utsname.h>


int main(int argc, char **argv) {

#ifdef __aarch64__
    std::cout << "[INFO] Running on AArch64." << std::endl;
#elif defined(__arm__)
    std::cout << "[INFO] Running on ARM (ARMv7 or older)." << std::endl;
#elif defined(__x86_64__)
    std::cout << "[INFO] Running on x86_64." << std::endl;
#else
    std::cout << "[Warning] Running on unkown architecture." << std::endl;
#endif

    struct utsname sys_info;
    if (uname(&sys_info) == 0) {
        std::cout << "[INFO] System Name: " << sys_info.sysname  << std::endl;
        std::cout << "[INFO] Node Name: "   << sys_info.nodename << std::endl;
        std::cout << "[INFO] Release: "     << sys_info.release  << std::endl;
        std::cout << "[INFO] Version: "     << sys_info.version  << std::endl;
        std::cout << "[INFO] Machine: "     << sys_info.machine  << std::endl;
    }
    else {
        std::cerr << "[ERROR] Cannot obtain systems information with uname." << std::endl;
    }

    return 0;
}
