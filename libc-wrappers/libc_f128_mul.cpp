#include "src/__support/FPUtil/generic/mul.h"
#include "include/llvm-libc-types/float128.h"

using namespace LIBC_NAMESPACE;

extern "C" float128 libc_multf3(float128 a, float128 b) {
    return fputil::generic::mul<float128>(a, b);
}
