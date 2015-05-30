#!/bin/bash
NDK=~/Android/android-ndk-r10e
SYSROOT=$NDK/platforms/android-16/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64

CPU=arm
PREFIX=android/$CPU
ADDI_CFLAGS="-marm -g"

export PATH=$TOOLCHAIN/bin:$PATH
export CC=arm-linux-androideabi-gcc
export LD=arm-linux-androideabi-ld
export AR=arm-linux-androideabi-ar


function build_android
{
	./configure 												\
		--prefix=$PREFIX 										\
		--enable-shared 										\
		--disable-symver										\
		--disable-static										\
		--disable-ffserver 										\
		--disable-ffplay										\
		--disable-ffprobe										\
		--enable-cross-compile 									\
		--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- 	\
		--target-os=linux 										\
		--arch=arm 												\
		--sysroot=$SYSROOT 										\
		--extra-cflags="-O0 -fpic $ADDI_CFLAGS" 				\
		--extra-ldflags="$ADDI_LDFLAGS" 						\
		--disable-doc 											\
		--disable-htmlpages  									\
		--disable-manpages 										\
		--disable-podpages 										\
		--disable-txtpages 										


	rm /dist
	make -j7
	make install
}
echo $NDK
# build_android

$CC -lm -lz -shared --sysroot=$SYSROOT -Wl,--no-undefined -Wl,-z,noexecstack $EXTRA_LDFLAGS libavutil/*.o		\
libavutil/arm/*.o libavcodec/*.o libavcodec/arm/*.o libavformat/*.o libswresample/*.o libswscale/*.o -o			\
./libffmpeg-all.so

