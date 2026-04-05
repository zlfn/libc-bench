#include "src/__support/FPUtil/generic/mul.h"
using namespace LIBC_NAMESPACE;
extern "C" float libc_mulsf3(float a, float b) {
    return fputil::generic::mul<float>(a, b);
}
