# Linux-Hosted GNU Cross-Toolchain for Windows Arm64 (MinGW/Cygwin)

[![Prerelease Test](https://github.com/eukarpov/gnu-toolchain-windows-arm64/actions/workflows/prerelease-test.yml/badge.svg)](https://github.com/eukarpov/gnu-toolchain-windows-arm64/actions/workflows/prerelease-test.yml) [![Daily Rebase](https://github.com/eukarpov/gnu-toolchain-windows-arm64/actions/workflows/rebase.yml/badge.svg)](https://github.com/eukarpov/gnu-toolchain-windows-arm64/actions/workflows/rebase.yml)

GNU Cross-Toolchain for Windows Arm64 with MinGW (`aarch64-w64-mingw32`) and Cygwin
(`aarch64-pc-cygwin`) targets on Linux hosts (`x86_64-pc-linux-gnu` or
`aarch64-pc-linux-gnu`).
It is a **work in progress**, with ongoing efforts to upstream the necessary changes to
the corresponding repositories. The resulting toolchain produces binaries that can be executed
on Windows on Arm64 and are built on Linux. The scripts are actively tested on the default
Ubuntu 22.04 GitHub Actions runners and Ubuntu 22.04 in WSL.

# Known Issues

This toolchain is not yet ready for real-world use. Problems and missing parts are listed in
the [issues](https://github.com/eukarpov/gnu-toolchain-windows-arm64/issues). Please,
report all issues, even if the issue is, e.g., GCC-specific, here.

# Installing Build Dependencies

The [main build script](https://github.com/eukarpov/gnu-toolchain-windows-arm64/blob/main/build.sh)
installs its dependencies automatically when the `RUN_BOOTSTRAP=1` environment variable is defined,
which is the default. To see what will be installed refer to
[`.github/scripts/install-dependencies.sh`](https://github.com/eukarpov/gnu-toolchain-windows-arm64/blob/main/.github/scripts/install-dependencies.sh).

# Building the Cross-Compiler

To build the cross-compiler and install it into a `~/cross-aarch64-w64-mingw32-msvcrt` folder,
follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/eukarpov/gnu-toolchain-windows-arm64.git
   ```

2. Navigate to the root repository folder:
   ```bash
   cd gnu-toolchain-windows-arm64
   ```

3. Run the build script:
   ```bash
   ./build.sh
   ```

The toolchain uses the `aarch64-w64-mingw32` target by default. The `PLATFORM`
variable should be specified to change the target to `aarch64-pc-cygwin`.
```bash
PLATFORM=pc-cygwin ./build.sh
```

To install the toolchain into a different folder `TOOLCHAIN_PATH` environment
variable should be used:
```bash
TOOLCHAIN_PATH=/opt/aarch64-w64-mingw32 ./build.sh
```

To skip the dependencies bootstrapping process and fetching source code repositories for consecutive
builds `RUN_BOOTSTRAP` and `UPDATE_SOURCES` environment variables should be used:
```bash
RUN_BOOTSTRAP=0 UPDATE_SOURCES=0 ./build.sh
```

The build script does multiple things:

- Installs the dependency Ubuntu packages.
- Clones several dependency source code repositories:
  - modified binutils from [eukarpov/binutils-windows-arm64](https://github.com/eukarpov/binutils-windows-arm64),
  - modified GCC from [eukarpov/gcc-windows-arm64](https://github.com/eukarpov/gcc-windows-arm64),
  - modified MinGW from [eukarpov/mingw-windows-arm64](https://github.com/eukarpov/mingw-windows-arm64).
  - modified Cygwin from [eukarpov/cygwin-windows-arm64](https://github.com/eukarpov/cygwin-windows-arm64).
- Bootstraps the binutils and GCC sources with `gmp`, `mpfr`, `isl`, etc. dependencies.
- Builds and installs binutils, stage 1 GCC, MinGW runtimes, GCC with libgcc, and then
  the entire MinGW.

# Using the Cross-Compiler

After building the toolchain, to build a simple C source code file run:
```bash
export PATH="~/cross-aarch64-w64-mingw32-msvcrt/bin:$PATH"
aarch64-w64-mingw32-gcc hello.c -o hello.exe
```

To build a set of basic AArch64-specific tests:
```bash
.github/scripts/tests/build.sh
```

The test script requires a working CMake executable in the environment and will place the resulting binaries
into the `tests/build/bin` folder.

# Testing the Toolchain

The toolchain is [tested](https://github.com/eukarpov/gnu-toolchain-windows-arm64/actions/workflows/build-and-test-toolchain.yml)
with the GCC test suite and against [four example projects builds](https://github.com/eukarpov/gnu-toolchain-windows-arm64/actions/workflows/prerelease-test.yml)
([OpenSSL](https://openssl-library.org/), [FFmpeg](https://ffmpeg.org/),
[OpenBLAS](https://github.com/OpenMathLib/OpenBLAS), [libjpeg-turbo](https://github.com/libjpeg-turbo/libjpeg-turbo))
and their testing suites.

As of 2024/08/09 the toolchain has reached the following level of quality with the GCC testing targeting
armv8-a without optional extensions such as SVE:

| Metric               | Count  |
| -------------------- | ------ |
| Expected passes      | 573324 |
| Unexpected failures  | 12118  |
| Unexpected successes | 172    |
| Expected failures    | 4528   |
| Unresolved testcases | 7363   |
| Unsupported tests    | 10774  |
| DejaGnu errors       | 0      |
| Total                | 608279 |
| Reliability rate     | 96%    |
