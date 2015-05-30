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
 */
package com.example.hellojni;

import no.hyper.ffmpegwrapper.FfmpegService;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class HelloJni extends Activity {
	FfmpegService ffmpegService;
	
	private static final String CMD_SAMPLE = "ffmpeg -i /storage/sdcard1/1080p.3gp -s 480x320 -y /storage/sdcard1/output.mpeg";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		ffmpegService = new FfmpegService();
		
		Button btn = new Button(this);
		setContentView(btn);

		btn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				ffmpegService.execute(CMD_SAMPLE.toCharArray());
			}

		});
	}

}
