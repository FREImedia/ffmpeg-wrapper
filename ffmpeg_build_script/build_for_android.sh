#!/bin/bash

###
# This script builds FFMPEG and setups the project to work "out-of-the-box"
# Simply modifiy the paths in the SETUP-part of this file.
# The script will build ffmpeg and place the files in the android project
# (do not modify project structure!)
###


# SETUP
NDK=~/Library/Android/sdk/ndk-bundle
FFMPEG_SRC=/Users/mat/Downloads/ffmpeg-3.1.1

FLAVOUR=armeabi-v7a
CPU=arm


# DO NOT CHANGE BELOW THIS LINE
# ==============================
# ( Okay, maybe you can change this if you know what you are doing :-) )
#
SYSROOT=${NDK}/platforms/android-16/arch-arm/
TOOLCHAIN=${NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

PREFIX=android/${CPU}
ADDI_CFLAGS="-marm -g"
ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PATH=${TOOLCHAIN}/bin:$PATH
export CC=${TOOLCHAIN}/bin/arm-linux-androideabi-gcc-4.9
export LD=${TOOLCHAIN}/bin/arm-linux-androideabi-ld
export AR=${TOOLCHAIN}/bin/arm-linux-androideabi-ar


# Build ffmpeg for android
function build_android {
    echo "Building FFMPEG..."
	./configure 									\
		--prefix=${PREFIX} 										\
		--enable-shared 										\
		--disable-symver										\
		--disable-static										\
		--disable-ffserver 										\
		--disable-ffplay										\
		--disable-ffprobe										\
		--enable-cross-compile 									\
		--cross-prefix=${TOOLCHAIN}/bin/arm-linux-androideabi- 	\
		--target-os=linux 										\
		--arch=arm 												\
		--sysroot=${SYSROOT}									\
		--extra-cflags="-O0 -fpic ${ADDI_CFLAGS}" 				\
		--extra-ldflags="${ADDI_LDFLAGS}" 						\
		--disable-doc 											\
		--disable-htmlpages  									\
		--disable-manpages 										\
		--disable-podpages 										\
		--disable-txtpages 										


	rm -rf ${FFMPEG_SRC}/${PREFIX}
	make
	make install
}


# workaround for duplicate functions (dirty)
function remove_duplicates {
    echo "Removing duplicates (Workaround..)"

    rm ${FFMPEG_SRC}/libavutil/log2_tab.o
    rm ${FFMPEG_SRC}/libavcodec/golomb.o
    rm ${FFMPEG_SRC}/libavformat/log2_tab.o
    rm ${FFMPEG_SRC}/libswscale/log2_tab.o
    rm ${FFMPEG_SRC}/libswresample/log2_tab.o
    rm ${FFMPEG_SRC}/libavfilter/log2_tab.o

    rm ${FFMPEG_SRC}/libavcodec/reverse.o
}



# combine .so files to a single one
function combine_libs {
    echo "Combining libraries to a single one..."

    $CC -lm -lz -shared --sysroot=${SYSROOT} -Wl,--no-undefined -Wl,-z,noexecstack ${EXTRA_LDFLAGS} \
    libavutil/*.o libavutil/arm/*.o libavcodec/*.o libavcodec/arm/*.o libavformat/*.o libavfilter/*.o   \
    libavdevice/*.o libswresample/*.o libswscale/*.o libswscale/arm/*.o libswresample/arm/*.o compat/*.o   \
     -o ./libffmpeg-all.so
}


# setting up project
function setup_project {
    echo "Setting up project and copying files..."
    cd ${ABSOLUTE_PATH}

    # Libs
    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniLibs/
    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniLibs/${FLAVOUR}
    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniLibs/${FLAVOUR}/bin

    cp ${FFMPEG_SRC}/${PREFIX}/bin/* ${ABSOLUTE_PATH}/../app/src/main/jniLibs/${FLAVOUR}/bin/
    cp ${FFMPEG_SRC}/libffmpeg-all.so ${ABSOLUTE_PATH}/../app/src/main/jniLibs/${FLAVOUR}/libffmpeg.so


    # Header
    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/
    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}
    rm -rf ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/
    rm -rf ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/
    cp -R ${FFMPEG_SRC}/${PREFIX}/include/* ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/

    # Other headers
    cp ${FFMPEG_SRC}/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/compat/
    cp ${FFMPEG_SRC}/compat/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/compat/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavresample/
    cp ${FFMPEG_SRC}/libavresample/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavresample/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavutil/
    cp ${FFMPEG_SRC}/libavutil/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavutil/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavutil/arm/
    cp ${FFMPEG_SRC}/libavutil/arm/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavutil/arm/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavformat/
    cp ${FFMPEG_SRC}/libavformat/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavformat/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libpostproc/
    cp ${FFMPEG_SRC}/libpostproc/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libpostproc/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavcodec/
    cp ${FFMPEG_SRC}/libavcodec/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavcodec/

    mkdir -p ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavcodec/arm
    cp ${FFMPEG_SRC}/libavcodec/arm/*.h ${ABSOLUTE_PATH}/../app/src/main/jniInclude/${FLAVOUR}/libavcodec/arm/
}


# RUN
echo "NDK path: ${NDK}"
echo "FFMPEG path: ${FFMPEG_SRC} \n"
cd ${FFMPEG_SRC}

build_android
remove_duplicates
combine_libs
setup_project


echo "Done"