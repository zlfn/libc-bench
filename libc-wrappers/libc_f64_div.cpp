#include "src/__support/FPUtil/generic/div.h"
using namespace LIBC_NAMESPACE;
extern "C" double libc_divdf3(double a, double b) {
    return fputil::generic::div<double>(a, b);
}
