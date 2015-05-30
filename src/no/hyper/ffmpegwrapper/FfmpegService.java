package no.hyper.ffmpegwrapper;

public class FfmpegService {
	static {
		System.loadLibrary("avutil-54");
		System.loadLibrary("swscale-3");
		System.loadLibrary("swresample-1");
		System.loadLibrary("avcodec-56");
		System.loadLibrary("avformat-56");
		System.loadLibrary("avfilter-5");
		System.loadLibrary("avdevice-56");
		System.loadLibrary("ffmpeg-app");
	}
	
	public int execute(final char[] cmd, final Callback cb){
		new Thread(){
			@Override
			public void run() {
				int ret = __execute(cmd);
				cb.onFinish(ret);
			}
			
		}.start();
		
		return 1;
	}

	/*
	 * Synchronous call
	 */
	private native int __execute(char[] cmd);

	/*
	 * Asynchronous call, returned by onCancel
	 */
	public native void cancel();

	/*
	 * A callback method for JNI layer, to broadcast the progress
	 */
	public void onProgress(int percentage) {
	}

	/*
	 * Invoked when cancellation is success.
	 */
	public void onCancel() {
	}

	public interface Callback {
		public void onFinish(final int ret);
		public void onProgress(int percent);
	}
}
