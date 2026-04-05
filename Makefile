# libc-bench: compiler-rt vs LLVM libc floating-point benchmark
#
# Usage:
#   make                    # build everything
#   make bench              # run benchmark
#   make size               # compare code sizes
#   make clean              # clean build artifacts
#
# Environment variables:
#   LLVM_PROJECT_DIR  - path to llvm-project checkout (default: ~/Main/llvm-project)
#   OPT               - optimization level (default: -O2)

ifndef LLVM_PROJECT_DIR
$(error LLVM_PROJECT_DIR is not set. Usage: LLVM_PROJECT_DIR=/path/to/llvm-project make)
endif
CC               := clang
CXX              := clang++
OPT              ?= -O2

LIBC_DIR         := $(LLVM_PROJECT_DIR)/libc
CRT_SRC          := $(LLVM_PROJECT_DIR)/compiler-rt/lib/builtins
LIBC_WRAP        := libc-wrappers
BENCH_DIR        := bench
BUILD            := build

CFLAGS           := $(OPT) -I$(CRT_SRC) -Wno-macro-redefined
CXXFLAGS         := $(OPT) -std=c++17 -ffreestanding -fno-exceptions -fno-rtti \
                    -I$(LIBC_DIR) \
                    -DLIBC_NAMESPACE=__llvm_libc \
                    -DLIBC_FULL_BUILD \
                    -DLIBC_MATH_HAS_NO_ERRNO \
                    -DLIBC_MATH_HAS_NO_EXCEPT

# ============================================================
# compiler-rt objects
# ============================================================
$(BUILD)/crt_addtf3.o: $(CRT_SRC)/addtf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_subtf3.o: $(CRT_SRC)/subtf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_multf3.o: $(CRT_SRC)/multf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_divtf3.o: $(CRT_SRC)/divtf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_adddf3.o: $(CRT_SRC)/adddf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_subdf3.o: $(CRT_SRC)/subdf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_muldf3.o: $(CRT_SRC)/muldf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_divdf3.o: $(CRT_SRC)/divdf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_addsf3.o: $(CRT_SRC)/addsf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_subsf3.o: $(CRT_SRC)/subsf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_mulsf3.o: $(CRT_SRC)/mulsf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_divsf3.o: $(CRT_SRC)/divsf3.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_fp_mode.o: $(CRT_SRC)/fp_mode.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/crt_int_util.o: $(CRT_SRC)/int_util.c | $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<

CRT_ALL_OBJS := $(BUILD)/crt_addtf3.o $(BUILD)/crt_subtf3.o $(BUILD)/crt_multf3.o $(BUILD)/crt_divtf3.o \
                $(BUILD)/crt_adddf3.o $(BUILD)/crt_subdf3.o $(BUILD)/crt_muldf3.o $(BUILD)/crt_divdf3.o \
                $(BUILD)/crt_addsf3.o $(BUILD)/crt_subsf3.o $(BUILD)/crt_mulsf3.o $(BUILD)/crt_divsf3.o \
                $(BUILD)/crt_fp_mode.o $(BUILD)/crt_int_util.o

# ============================================================
# libc wrapper objects (one per function)
# ============================================================
$(BUILD)/libc_f128_add.o: $(LIBC_WRAP)/libc_f128_add.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f128_sub.o: $(LIBC_WRAP)/libc_f128_sub.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f128_mul.o: $(LIBC_WRAP)/libc_f128_mul.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f128_div.o: $(LIBC_WRAP)/libc_f128_div.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f64_add.o: $(LIBC_WRAP)/libc_f64_add.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f64_sub.o: $(LIBC_WRAP)/libc_f64_sub.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f64_mul.o: $(LIBC_WRAP)/libc_f64_mul.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f64_div.o: $(LIBC_WRAP)/libc_f64_div.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f32_add.o: $(LIBC_WRAP)/libc_f32_add.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f32_sub.o: $(LIBC_WRAP)/libc_f32_sub.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f32_mul.o: $(LIBC_WRAP)/libc_f32_mul.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/libc_f32_div.o: $(LIBC_WRAP)/libc_f32_div.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

LIBC_ALL_OBJS := $(BUILD)/libc_f128_add.o $(BUILD)/libc_f128_sub.o $(BUILD)/libc_f128_mul.o $(BUILD)/libc_f128_div.o \
                 $(BUILD)/libc_f64_add.o $(BUILD)/libc_f64_sub.o $(BUILD)/libc_f64_mul.o $(BUILD)/libc_f64_div.o \
                 $(BUILD)/libc_f32_add.o $(BUILD)/libc_f32_sub.o $(BUILD)/libc_f32_mul.o $(BUILD)/libc_f32_div.o

# ============================================================
# Benchmark binary
# ============================================================
$(BUILD)/bench: $(BENCH_DIR)/bench.cpp $(CRT_ALL_OBJS) $(LIBC_ALL_OBJS) | $(BUILD)
	$(CXX) $(OPT) -std=c++17 -o $@ $< $(CRT_ALL_OBJS) $(LIBC_ALL_OBJS) -lbenchmark -lpthread

$(BUILD):
	mkdir -p $(BUILD)

# ============================================================
# Targets
# ============================================================
.PHONY: all bench size clean

all: $(BUILD)/bench

bench: $(BUILD)/bench
	@echo ""
	@echo "=== Running Benchmark ==="
	@echo ""
	@$(BUILD)/bench

TEXTSIZE = size -A $(1) | awk '/^\.text/{s+=$$2} END{print s+0}'

size: $(CRT_ALL_OBJS) $(LIBC_ALL_OBJS)
	@echo ""
	@echo "=== Code Size Comparison (text section bytes) ==="
	@echo ""
	@printf "%-20s %12s %12s %10s\n" "Function" "compiler-rt" "libc" "ratio"
	@printf "%-20s %12s %12s %10s\n" "--------" "-----------" "----" "-----"
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_addtf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f128_add.o)); printf "%-20s %12d %12d %9.2fx\n" "f128 add" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_subtf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f128_sub.o)); printf "%-20s %12d %12d %9.2fx\n" "f128 sub" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_multf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f128_mul.o)); printf "%-20s %12d %12d %9.2fx\n" "f128 mul" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_divtf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f128_div.o)); printf "%-20s %12d %12d %9.2fx\n" "f128 div" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_adddf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f64_add.o)); printf "%-20s %12d %12d %9.2fx\n" "f64 add" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_subdf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f64_sub.o)); printf "%-20s %12d %12d %9.2fx\n" "f64 sub" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_muldf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f64_mul.o)); printf "%-20s %12d %12d %9.2fx\n" "f64 mul" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_divdf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f64_div.o)); printf "%-20s %12d %12d %9.2fx\n" "f64 div" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_addsf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f32_add.o)); printf "%-20s %12d %12d %9.2fx\n" "f32 add" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_subsf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f32_sub.o)); printf "%-20s %12d %12d %9.2fx\n" "f32 sub" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_mulsf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f32_mul.o)); printf "%-20s %12d %12d %9.2fx\n" "f32 mul" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)
	@CRT=$$($(call TEXTSIZE,$(BUILD)/crt_divsf3.o)); LIBC=$$($(call TEXTSIZE,$(BUILD)/libc_f32_div.o)); printf "%-20s %12d %12d %9.2fx\n" "f32 div" $$CRT $$LIBC $$(echo "scale=2; $$LIBC / $$CRT" | bc)

clean:
	rm -rf $(BUILD)
