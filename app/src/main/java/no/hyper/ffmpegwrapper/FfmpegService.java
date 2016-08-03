package no.hyper.ffmpegwrapper;

public class FfmpegService {
	static {
//		System.loadLibrary("avutil");
//		System.loadLibrary("swscale");
//		System.loadLibrary("swresample");
//		System.loadLibrary("avcodec");
//		System.loadLibrary("avformat");
//		System.loadLibrary("avfilter");
//		System.loadLibrary("avdevice");
		System.loadLibrary("ffmpeg");
		System.loadLibrary("native");
	}
	
	public int execute(final String cmd, final Callback cb){
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
	private native int __execute(String cmd);

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
