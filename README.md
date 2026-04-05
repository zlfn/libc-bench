# libc-bench

LLVM compiler-rt vs LLVM libc floating-point benchmark

```
Usage:
  make                    # build everything
  make bench              # run benchmark
  make size               # compare code sizes
  make clean              # clean build artifacts
  
Environment variables:
  LLVM_PROJECT_DIR  - path to llvm-project checkout
  OPT               - optimization level (default: -O2)
```
