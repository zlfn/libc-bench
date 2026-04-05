#include "src/__support/FPUtil/generic/mul.h"
using namespace LIBC_NAMESPACE;
extern "C" double libc_muldf3(double a, double b) {
    return fputil::generic::mul<double>(a, b);
}
