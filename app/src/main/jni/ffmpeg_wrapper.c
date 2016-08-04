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
#include <libavcodec/jni.h>
#include "ffmpeg_wrapper.h"

jmp_buf jmp_exit;

#define MODULE_FFMPEG "FFMPEG"

extern int main(int argc, char** argv);


static void log_callback_android(void *ptr, int level, const char *fmt, va_list vl)
{
	__android_log_vprint(ANDROID_LOG_INFO, MODULE_FFMPEG, fmt, vl);
}


JNIEXPORT jint JNICALL Java_no_hyper_ffmpegwrapper_FfmpegService__1_1execute
  (JNIEnv *env, jobject self, jstring jCmd)
{
	int i;
	char* argv[32] = {0};
	char* pch;
	int argc = 0;
	char *cmd;

	const char *tmp = (*env)->GetStringUTFChars(env, jCmd, 0);
	i = (*env)->GetStringUTFLength(env, jCmd);
	cmd = calloc(sizeof(const char), i);
	strcpy(cmd, tmp);
	(*env)->ReleaseStringUTFChars(env, jCmd, tmp);

	__android_log_print(ANDROID_LOG_INFO, MODULE_FFMPEG, "cmd=[%s]", cmd);

	pch = strtok(cmd, " ");
	while (pch != NULL)
	{
		argv[argc++] = pch;
		pch = strtok(NULL, " ");
	}

	for (i = 0; i < argc; i++)
		__android_log_print(ANDROID_LOG_INFO, MODULE_FFMPEG, "argv[%d]=%s", i, argv[i]);

	av_log_set_callback(log_callback_android);

	if(setjmp(jmp_exit))
		return i;

	main(argc, argv);

    // Enable mediacodec
    JavaVM* jvm;
    (*env)->GetJavaVM(env, &jvm);
    av_jni_set_java_vm(&jvm, NULL);

	free (cmd);
	return 0;
}

JNIEXPORT void JNICALL Java_no_hyper_ffmpegwrapper_FfmpegService_cancel
  (JNIEnv * env, jobject self)
{
}

jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    JNIEnv* env;
    //if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK) {
    if ((*vm)->GetEnv(vm, (void **) &env, JNI_VERSION_1_6) != JNI_OK) {
        return -1;
    }

    // Get jclass with env->FindClass.
    // Register methods with env->RegisterNatives.

    return JNI_VERSION_1_6;
}



