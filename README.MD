## Environment
- SYSTEM: Ubuntu 20.04.4 LTS
- NDK: android-ndk-r23c-linux
- LIBCURL: 7.84.0
- OPENSSL: 1.1.1q
- ZLIB: 1.2.12 (NOT USE)
- API TARGET: 21
- PLATFORM TARGET: armv7a/aarch64

## Precompiled binaries
You can find precompiled binaries at:
- LIBCURL: curl-7.84.0/out
- OPENSSL: openssl-1.1.1q/out

## Linking
You should link this libraries:
- libcrypto.a
- libssl.a
- libcurl.a
- libz.a (provided by ndk)

---

## 环境
- SYSTEM: Ubuntu 20.04.4 LTS
- NDK: android-ndk-r23c-linux
- LIBCURL: 7.84.0
- OPENSSL: 1.1.1q
- ZLIB: 1.2.12 (未使用)
- API TARGET: 21
- PLATFORM TARGET: armv7a/aarch64

## 预编译文件
预编译文件保存在以下位置：
- LIBCURL: ./curl-7.84.0/out
- OPENSSL: ./openssl-1.1.1q/out

## 链接
使用时需要链接以下静态库：
- libcrypto.a
- libssl.a
- libcurl.a
- libz.a (由 ndk 提供)