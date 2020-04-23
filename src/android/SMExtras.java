package com.strummachine.cordova;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;

import android.view.WindowManager;
import android.content.Intent;

import android.media.AudioTimestamp;
import android.media.AudioTrack;

import android.util.Log;

import java.lang.reflect.Method;
import android.media.AudioFormat;
import android.media.AudioManager;


public class SMExtras extends CordovaPlugin {

  private Method getLatencyMethod;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    try {
      getLatencyMethod = AudioTrack.class.getMethod("getLatency", (Class<?>[]) null);
    } catch (Throwable e) {
      // There's no guarantee this method exists. Do nothing.
    }
  }

  @Override
  public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
    if ("disableIdleTimeout".equals(action)) {
      this.disableIdleTimeout(callbackContext);
      return true;
    }

    if ("enableIdleTimeout".equals(action)) {
      this.enableIdleTimeout(callbackContext);
      return true;
    }

    if ("share".equals(action)) {
      String text = args.getString(0);
      String title = args.getString(1);
      this.share(text, title, callbackContext);
      return true;
    }

    if ("getLatency".equals(action)) {
      this.getLatency(callbackContext);
      return true;
    }

    return false;
  }

  private void disableIdleTimeout(CallbackContext callbackContext) {
    cordova.getActivity().runOnUiThread(new Runnable() {
      public void run() {
        cordova.getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
      }
    });
    callbackContext.success();
  }

  private void enableIdleTimeout(CallbackContext callbackContext) {
    cordova.getActivity().runOnUiThread(new Runnable() {
      public void run() {
        cordova.getActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
      }
    });
    callbackContext.success();
  }

  private void share(String text, String title, CallbackContext callbackContext) {
    try {
      Intent sendIntent = new Intent();
      sendIntent.setAction(Intent.ACTION_SEND);
      sendIntent.putExtra(Intent.EXTRA_TEXT, text);
      sendIntent.setType("text/plain");
      Intent shareIntent = Intent.createChooser(sendIntent, title);
      cordova.getActivity().startActivity(shareIntent);
      callbackContext.success();
    } catch(Error e) {
      callbackContext.error(e.getMessage());
    }
  }

  private void getLatency(CallbackContext callbackContext) {
    try {
      if ( getLatencyMethod != null ) {
        try {
          Integer sampleRate = 44100;
          Integer bufferSize = AudioTrack.getMinBufferSize(sampleRate, AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT);
          Integer frameSize = 2 * 2; // two channels of 16 bit (2-byte) PCM audio
          Integer bufferSizeMs = 1000 * (bufferSize / frameSize) / audioTrack.getSampleRate();
          AudioTrack audioTrack = new AudioTrack(
            AudioManager.STREAM_MUSIC,
            sampleRate,
            AudioFormat.CHANNEL_OUT_STEREO,
            AudioFormat.ENCODING_PCM_16BIT,
            bufferSize,
            AudioTrack.MODE_STREAM);
          Integer latencyMs = (Integer) getLatencyMethod.invoke(audioTrack, (Object[]) null) - bufferSizeMs;
          if (latencyMs > 3000) {  // Sanity check that the latency is less than 3 seconds
            callbackContext.error("Reported latency (" + latencyMs + "ms) is too large.");
          } else {
            callbackContext.success(latencyMs);
          }
          audioTrack.release();
        } catch (Exception e) {
          callbackContext.error(e.getMessage());
        }
      } else {
        callbackContext.success(0);
      }
    } catch(Error e) {
      callbackContext.error(e.getMessage());
    }
  }
}
