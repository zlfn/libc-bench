#include <benchmark/benchmark.h>
#include <cstdint>
#include <cstring>
#include <random>

// ============================================================
// Declarations: compiler-rt builtins
// ============================================================
extern "C" {
__float128 __addtf3(__float128 a, __float128 b);
__float128 __subtf3(__float128 a, __float128 b);
__float128 __multf3(__float128 a, __float128 b);
__float128 __divtf3(__float128 a, __float128 b);
double __adddf3(double a, double b);
double __subdf3(double a, double b);
double __muldf3(double a, double b);
double __divdf3(double a, double b);
float __addsf3(float a, float b);
float __subsf3(float a, float b);
float __mulsf3(float a, float b);
float __divsf3(float a, float b);
}

// ============================================================
// Declarations: libc wrappers
// ============================================================
extern "C" {
__float128 libc_addtf3(__float128 a, __float128 b);
__float128 libc_subtf3(__float128 a, __float128 b);
__float128 libc_multf3(__float128 a, __float128 b);
__float128 libc_divtf3(__float128 a, __float128 b);
double libc_adddf3(double a, double b);
double libc_subdf3(double a, double b);
double libc_muldf3(double a, double b);
double libc_divdf3(double a, double b);
float libc_addsf3(float a, float b);
float libc_subsf3(float a, float b);
float libc_mulsf3(float a, float b);
float libc_divsf3(float a, float b);
}

// ============================================================
// Input arrays (pre-generated with std::random)
// ============================================================
constexpr int N = 1024;

static __float128 f128_a[N], f128_b[N];
static double     f64_a[N],  f64_b[N];
static float      f32_a[N],  f32_b[N];

static void init_inputs() {
    std::mt19937_64 rng(42);

    // f128: generate random normal (non-inf/nan) values
    std::uniform_int_distribution<uint64_t> dist64;
    for (int i = 0; i < N; i++) {
        auto gen = [&]() {
            __uint128_t bits = ((__uint128_t)dist64(rng) << 64) | dist64(rng);
            bits &= ((__uint128_t)0x7FFE << 112) | (((__uint128_t)1 << 112) - 1);
            __float128 f;
            memcpy(&f, &bits, sizeof(f));
            return f;
        };
        f128_a[i] = gen();
        f128_b[i] = gen();
    }

    // f64: generate random normal (non-inf/nan) values
    for (int i = 0; i < N; i++) {
        auto gen = [&]() {
            uint64_t bits = dist64(rng) & 0x7FEFFFFFFFFFFFFFULL;
            double f;
            memcpy(&f, &bits, sizeof(f));
            return f;
        };
        f64_a[i] = gen();
        f64_b[i] = gen();
    }

    // f32: generate random normal (non-inf/nan) values
    std::uniform_int_distribution<uint32_t> dist32;
    for (int i = 0; i < N; i++) {
        auto gen = [&]() {
            uint32_t bits = dist32(rng) & 0x7F7FFFFF;
            float f;
            memcpy(&f, &bits, sizeof(f));
            return f;
        };
        f32_a[i] = gen();
        f32_b[i] = gen();
    }
}

// ============================================================
// Benchmark template
// ============================================================
#define DEFINE_BENCH(name, type, arr_a, arr_b, func) \
static void name(benchmark::State& state) { \
    int i = 0; \
    for (auto _ : state) { \
        type r = func(arr_a[i], arr_b[i]); \
        benchmark::DoNotOptimize(r); \
        i = (i + 1) & (N - 1); \
    } \
}

// ============================================================
// f128 benchmarks
// ============================================================
DEFINE_BENCH(BM_crt_f128_add,  __float128, f128_a, f128_b, __addtf3)
DEFINE_BENCH(BM_crt_f128_sub,  __float128, f128_a, f128_b, __subtf3)
DEFINE_BENCH(BM_crt_f128_mul,  __float128, f128_a, f128_b, __multf3)
DEFINE_BENCH(BM_crt_f128_div,  __float128, f128_a, f128_b, __divtf3)
DEFINE_BENCH(BM_libc_f128_add, __float128, f128_a, f128_b, libc_addtf3)
DEFINE_BENCH(BM_libc_f128_sub, __float128, f128_a, f128_b, libc_subtf3)
DEFINE_BENCH(BM_libc_f128_mul, __float128, f128_a, f128_b, libc_multf3)
DEFINE_BENCH(BM_libc_f128_div, __float128, f128_a, f128_b, libc_divtf3)

BENCHMARK(BM_crt_f128_add);
BENCHMARK(BM_libc_f128_add);
BENCHMARK(BM_crt_f128_sub);
BENCHMARK(BM_libc_f128_sub);
BENCHMARK(BM_crt_f128_mul);
BENCHMARK(BM_libc_f128_mul);
BENCHMARK(BM_crt_f128_div);
BENCHMARK(BM_libc_f128_div);

// ============================================================
// f64 benchmarks
// ============================================================
DEFINE_BENCH(BM_crt_f64_add,  double, f64_a, f64_b, __adddf3)
DEFINE_BENCH(BM_crt_f64_sub,  double, f64_a, f64_b, __subdf3)
DEFINE_BENCH(BM_crt_f64_mul,  double, f64_a, f64_b, __muldf3)
DEFINE_BENCH(BM_crt_f64_div,  double, f64_a, f64_b, __divdf3)
DEFINE_BENCH(BM_libc_f64_add, double, f64_a, f64_b, libc_adddf3)
DEFINE_BENCH(BM_libc_f64_sub, double, f64_a, f64_b, libc_subdf3)
DEFINE_BENCH(BM_libc_f64_mul, double, f64_a, f64_b, libc_muldf3)
DEFINE_BENCH(BM_libc_f64_div, double, f64_a, f64_b, libc_divdf3)

BENCHMARK(BM_crt_f64_add);
BENCHMARK(BM_libc_f64_add);
BENCHMARK(BM_crt_f64_sub);
BENCHMARK(BM_libc_f64_sub);
BENCHMARK(BM_crt_f64_mul);
BENCHMARK(BM_libc_f64_mul);
BENCHMARK(BM_crt_f64_div);
BENCHMARK(BM_libc_f64_div);

// ============================================================
// f32 benchmarks
// ============================================================
DEFINE_BENCH(BM_crt_f32_add,  float, f32_a, f32_b, __addsf3)
DEFINE_BENCH(BM_crt_f32_sub,  float, f32_a, f32_b, __subsf3)
DEFINE_BENCH(BM_crt_f32_mul,  float, f32_a, f32_b, __mulsf3)
DEFINE_BENCH(BM_crt_f32_div,  float, f32_a, f32_b, __divsf3)
DEFINE_BENCH(BM_libc_f32_add, float, f32_a, f32_b, libc_addsf3)
DEFINE_BENCH(BM_libc_f32_sub, float, f32_a, f32_b, libc_subsf3)
DEFINE_BENCH(BM_libc_f32_mul, float, f32_a, f32_b, libc_mulsf3)
DEFINE_BENCH(BM_libc_f32_div, float, f32_a, f32_b, libc_divsf3)

BENCHMARK(BM_crt_f32_add);
BENCHMARK(BM_libc_f32_add);
BENCHMARK(BM_crt_f32_sub);
BENCHMARK(BM_libc_f32_sub);
BENCHMARK(BM_crt_f32_mul);
BENCHMARK(BM_libc_f32_mul);
BENCHMARK(BM_crt_f32_div);
BENCHMARK(BM_libc_f32_div);

// ============================================================
// main
// ============================================================
int main(int argc, char** argv) {
    init_inputs();
    benchmark::Initialize(&argc, argv);
    benchmark::RunSpecifiedBenchmarks();
    benchmark::Shutdown();
    return 0;
}
