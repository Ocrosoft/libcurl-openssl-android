#!/bin/bash

NDK_API=21
MAKE_CPU_CORE=12
OPENSSL_PATH=$(pwd)/openssl-1.1.1q
ZLIB_PATH=$(pwd)/zlib-1.2.12
CURL_PATH=$(pwd)/curl-7.84.0

check_error() {
    if [[ $? -ne 0 ]]; then
        err $@
        exit 1
    fi
}

readonly RED='\033[0;31m'
readonly NC='\033[0m'
err() {
    echo -e "${RED}$*${NC}" >&2
}

check_ndk() {
    if [[ "$NDK_ROOT" == "" ]]; then
        echo "NDK_ROOT should be set!"
        exit 1
    fi
}

setup_env() {
    local uname=`(uname -s || echo unknown)`
    local ndk_toolchain
    local ndk_target
  
    case "$uname" in
        Linux* | linux* | GNU | GNU/* | solaris*) ndk_toolchain=linux-x86_64 ;;
        Darwin* | darwin*) ndk_toolchain=darwin-x86_64 ;;
        unknown) err 'Failed to get device OS name.'; exit 1 ;;
        *) err "OS \'$uname\' is not supported."; exit 1 ;;
    esac

    case "$1" in
        arm) ndk_target=armv7a-linux-androideabi ;;
        arm64) ndk_target=aarch64-linux-android ;;
        *) err "ABI '$1' is not supported."; exit 1 ;;
    esac
  
    export NDK=$NDK_ROOT
    export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$ndk_toolchain
    export TARGET=$ndk_target
    export API=$NDK_API
    export AR=$TOOLCHAIN/bin/llvm-ar
    export CC=$TOOLCHAIN/bin/$TARGET$API-clang
    export AS=$CC
    export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
    export LD=$TOOLCHAIN/bin/ld
    export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
    export STRIP=$TOOLCHAIN/bin/llvm-strip
}

configure_openssl() {
    cd $OPENSSL_PATH

    export ANDROID_NDK_HOME=$NDK_ROOT
	PATH=$TOOLCHAIN/bin:$PATH
	./configure --prefix="$OPENSSL_PATH/out/$1" -D__ANDROID_API__=$NDK_API no-shared android-$1
    check_error "Configure openssl failed!"
}

build_openssl() {
    make clean
    make -j24
    check_error "Make openssl failed!"
    make install
    check_error "Install openssl failed!"
}

configure_zlib() {
    cd "$ZLIB_PATH"
    ./configure --prefix="$ZLIB_PATH/out/$1" --static
    check_error "Configure zlib failed!"
}

build_zlib() {
    make clean
    make -j24
    check_error "Make zlib failed!"
    make install
    check_error "Install zlib failed!"
}

configure_curl() {
    cd "$CURL_PATH"

    ./configure --prefix="$CURL_PATH/out/$1" --host $TARGET --with-pic --disable-shared --with-openssl="$OPENSSL_PATH/out/$1" #--with-zlib="$ZLIB_PATH/out/$1"
    check_error "Configure curl failed!"
}

build_curl() {
    make clean
    make -j24
    check_error "Make curl failed!"
    make install
    check_error "Install curl failed!"
}

check_ndk

for abi in arm arm64; do
    # 设置环境变量
    setup_env $abi
    # openssl
    configure_openssl $abi
    build_openssl
    # curl
    configure_curl $abi
    build_curl
done