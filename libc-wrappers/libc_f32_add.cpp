#include "src/__support/FPUtil/generic/add_sub.h"
using namespace LIBC_NAMESPACE;
extern "C" float libc_addsf3(float a, float b) {
    return fputil::generic::add<float>(a, b);
}
