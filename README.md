# alpine-cpp

Minimal C++ development environment including gcc, CMake, cppcheck and conan,
using Alpine Linux. This repo provides two docker images

alpine-cpp-x64:

  * `GCC Target: x86_64-alpine-linux-musl`
  * `getconf LONG_BIT: 64`

alpine-cpp-x86:

  * `GCC Target: i586-alpine-linux-musl`
  * `getconf LONG_BIT: 32`

## Caveats

The working directory is set to `/project` and this is a folder that should be
mounted from your host system to the docker image.

The image exposes as entrypoint the command `bash -c`, which allows you to give
a sequence of commands, all included in quotation symbols (`""`) and let bash
execute them. Alternatively, you can override the entrypoint by passing
`--entrypoint whatever_you_want` as argument to `docker` command.

In the case where you are running x86 images on a x64 host, uname will return
the host's kernel. Therefore tools that check the running kernel like conan and
cmake might produce wrong output. For `conan` the 32bit image exports
`CONAN_ENV_ARCH=x86` ; however for cmake or gcc you must configure them
properly to properly compile x86 binaries.

## Usage Examples

### conan based projects

```
docker run --rm -it -v $(pwd):/project -e CONAN_USER_HOME=/project pykler/alpine-cpp-x86:latest 'conan create ./ name/version@user/channel'
```

### CMake based projects

`docker run --rm -it -v $(pwd):/project pykler/alpine-cpp-x86:latest "mkdir -p build && cd build && cmake .. && make"`

### Makefile based projects

`docker run --rm -it -v $(pwd):/project pykler/alpine-cpp-x86:latest "make"`

### g++ based projects

`docker run --rm -it -v $(pwd):/project pykler/alpine-cpp-x86:latest "g++ yourfile.cpp youroutput.o"`

### Shell Access

`docker run --rm -it --entrypoint bash -v $(pwd):/project pykler/alpine-cpp-x86:latest`

## Building

```
docker build -t pykler/alpine-cpp-x64 . && \
sed 's#alpine:latest#i386/alpine:latest#' Dockerfile | docker build -t pykler/alpine-cpp-x86 -
docker image prune
docker push pykler/alpine-cpp-x64 && \
docker push pykler/alpine-cpp-x86
```
