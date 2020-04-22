package com.strummachine.cordova;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

import android.view.WindowManager;
import android.content.Intent;

import android.media.AudioTimestamp;
import android.media.AudioTrack;

import android.util.Log;


public class SMExtras extends CordovaPlugin {

  @Nullable private Method getLatencyMethod;
  @Nullable private AudioTrack audioTrack;
  private Integer sampleRate = 44100;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    try {
      getLatencyMethod = AudioTrack.class.getMethod("getLatency", (Class<?>[]) null);
    } catch (Throwable e) { //AMZN_CHANGE_ONELINE: Some legacy devices throw unexpected errors
      // There's no guarantee this method exists. Do nothing.
    }
    audioTrack = new AudioTrack(
      AudioManager.STREAM_MUSIC,
      sampleRate,
      AudioFormat.CHANNEL_OUT_MONO,
      AudioFormat.ENCODING_PCM_16BIT,
      AudioTrack.getMinBufferSize(sampleRate, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT), // buffer length in bytes
      AudioTrack.MODE_STATIC);
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
          Integer swLatencyMs = getLatencyMethod.invoke(Assertions.checkNotNull(audioTrack));
          // return swLatencyMs * (sampleRate / 1000);
          Log.i("swLatencyMs", String.valueOf(swLatencyMs));
          Log.i("sampleRate", String.valueOf(sampleRate));
          Log.i("System.nanoTime()", String.valueOf(System.nanoTime()));
          callbackContext.success(swLatencyMs * (sampleRate / 1000));
        } catch (Exception e) {
          callbackContext.success(-1);
        }
      } else {
        callbackContext.success(0);
      }
    } catch(Error e) {
      callbackContext.error(e.getMessage());
    }
  }
}
