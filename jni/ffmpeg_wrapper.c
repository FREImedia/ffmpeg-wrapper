/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
#include <string.h>
#include <jni.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <assert.h>
#include <android/log.h>
#include "ffmpeg_wrapper.h"

jmp_buf jmp_exit;

#define MODULE_FFMPEG "FFMPEG"

extern int __main(int argc, char** argv);

static void log_callback_android(void *ptr, int level, const char *fmt, va_list vl)
{
	__android_log_vprint(ANDROID_LOG_INFO, MODULE_FFMPEG, fmt, vl);
}

JNIEXPORT jint JNICALL Java_no_hyper_ffmpegwrapper_FfmpegService__1_1execute
  (JNIEnv *env, jobject self, jcharArray cmd)
{
	int i;
	char cmd0[] = "ffmpeg";
	char cmd1[] = "-i";
	// char cmd2[] = "/storage/sdcard1/1080p.3gp";
	char cmd2[] = "/storage/sdcard1/1080p.3gp";
   	char cmd3[] = "-s";
    char cmd4[] = "480x320";
    char cmd5[] = "-y";
	// char cmd5[] = "/storage/sdcard1/output.mpeg";
	char cmd6[] = "/storage/sdcard1/output.mpeg";

	char *argv[] = {cmd0, cmd1, cmd2, cmd3, cmd4, cmd5, cmd6};
       
	av_log_set_callback(log_callback_android);

	i = setjmp(jmp_exit);
	if (i)
		return i;

	__main(sizeof(argv)/sizeof(char*), argv);
	return 0;
}

JNIEXPORT void JNICALL Java_no_hyper_ffmpegwrapper_FfmpegService_cancel
  (JNIEnv * env, jobject self)
{
}
