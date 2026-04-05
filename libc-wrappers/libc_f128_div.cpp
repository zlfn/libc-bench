#include "src/__support/FPUtil/generic/div.h"
#include "include/llvm-libc-types/float128.h"

using namespace LIBC_NAMESPACE;

extern "C" float128 libc_divtf3(float128 a, float128 b) {
    return fputil::generic::div<float128>(a, b);
}
