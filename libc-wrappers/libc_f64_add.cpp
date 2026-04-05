#include "src/__support/FPUtil/generic/add_sub.h"
using namespace LIBC_NAMESPACE;
extern "C" double libc_adddf3(double a, double b) {
    return fputil::generic::add<double>(a, b);
}
