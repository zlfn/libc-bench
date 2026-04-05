#include "src/__support/FPUtil/generic/add_sub.h"
using namespace LIBC_NAMESPACE;
extern "C" float libc_subsf3(float a, float b) {
    return fputil::generic::sub<float>(a, b);
}
