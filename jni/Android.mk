# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(call my-dir)


include $(CLEAR_VARS)

LOCAL_MODULE    := ffmpeg-app
LOCAL_C_INCLUDES += /home/xiangzhc/Android/android-ndk-r10e/sources/ffmpeg-2.6.3/

# LOCAL_CFLAGS += -finstrument-functions
LOCAL_SRC_FILES := ffmpeg_wrapper.c cmdutils.c ffmpeg_filter.c ffmpeg.c ffmpeg_opt.c
LOCAL_SHARED_LIBRARIES := libavformat libavcodec libswscale libavutil libwsresample libavfilter libavdevice
LOCAL_LDLIBS := -llog -lz

include $(BUILD_SHARED_LIBRARY)

$(call import-module,ffmpeg-2.6.3/android/arm)

