#include "src/__support/FPUtil/generic/add_sub.h"
#include "include/llvm-libc-types/float128.h"

using namespace LIBC_NAMESPACE;

extern "C" float128 libc_addtf3(float128 a, float128 b) {
    return fputil::generic::add<float128>(a, b);
}
