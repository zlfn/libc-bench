#include "src/__support/FPUtil/generic/add_sub.h"
using namespace LIBC_NAMESPACE;
extern "C" double libc_subdf3(double a, double b) {
    return fputil::generic::sub<double>(a, b);
}
