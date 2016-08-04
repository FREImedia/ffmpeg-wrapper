FFMPEG is one of the most popular video/image processing library. Not only is it optimized for x86, but also for arm and
mips. Therefore not only does it run on powerful enterprise x86 servers, but also arm/mips based smartphone/tablets,
both iOS and Android.

This project mainly focus on Android platform.

=====================================
 What makes this project different
=====================================
1. Works as a library, not a single process. There are quite a few of ffmpeg-for-android open source projects in github,
those project uses ffmpeg as an independent process. 

2. Change the source code as little as possible. FFMPEG is a very dynamic project, which is upgraded very often. I want
to make sure the changes are very few, so that when it upgrades, I don't need to change too much.



# How to use ist

1) Clone repo
2) Download FFMPEG 3.1.1 source files
3) Set paths in ffmpeg_build_script/build_for_android.sh
4) run "sh ffmpeg_build_script/build_for_android.sh"
5) Open and build the project in Android Studio

The build-script will build FFMPEG and copy all needed files into the project.
Don't move or rename src/main/jniInclude and src/main/jniLibs



# What has changed

04.08.2016
==========
Updated scripts to work with FFMPEG-3.1.1


03.08.2016
===========
Transferred to a gradle-experimental:0.7.2 project in Android Studio
Works with FFMPEG 2.7.7
Updated build script to be a "out-of-the-box" solution - hopefully.


==============
1. main() -> __main()

2. hook log_infrastrucutre to Android's

3. exit() -> longjmp()
For an Linux app, 'exit on error' is a good enough approach, but not for a library - it would crash the whole process.
So all the exit is changed to longjmp back to Java layer



