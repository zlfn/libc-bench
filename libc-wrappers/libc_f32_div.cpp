#include "src/__support/FPUtil/generic/div.h"
using namespace LIBC_NAMESPACE;
extern "C" float libc_divsf3(float a, float b) {
    return fputil::generic::div<float>(a, b);
}
