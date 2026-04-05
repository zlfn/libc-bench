#include "src/__support/FPUtil/generic/add_sub.h"
#include "include/llvm-libc-types/float128.h"

using namespace LIBC_NAMESPACE;

extern "C" float128 libc_subtf3(float128 a, float128 b) {
    return fputil::generic::sub<float128>(a, b);
}
