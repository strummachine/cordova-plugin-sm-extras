package com.strummachine.cordova;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

import android.view.WindowManager;
import android.content.Intent;

public class SMExtras extends CordovaPlugin {

  @Override
  public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
    if (action.equalsIgnoreCase("disableIdleTimeout")) {
      this.disableIdleTimeout();
      return true;
    }

    if (action.equalsIgnoreCase("enableIdleTimeout")) {
      this.enableIdleTimeout();
      return true;
    }

    if (action.equalsIgnoreCase("share")) {
      String text = args.getString(0);
      String title = args.getString(1);
      this.share(text, title, callbackContext);
      return true;
    }

    callbackContext.error("unknown action: " + action);
    return false;
  }

  private void disableIdleTimeout() {
    cordova.getActivity().runOnUiThread(new Runnable() {
      public void run() {
        cordova.getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
      }
    });
  }

  private void enableIdleTimeout() {
    cordova.getActivity().runOnUiThread(new Runnable() {
      public void run() {
        cordova.getActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
      }
    });
  }

  private void share(String text, String title, CallbackContext callbackContext) {
    // try {
      Intent sendIntent = new Intent();
      sendIntent.setAction(Intent.ACTION_SEND);
      sendIntent.putExtra(Intent.EXTRA_TEXT, text);
      sendIntent.setType("text/plain");
      Intent shareIntent = Intent.createChooser(sendIntent, title);
      cordova.getActivity().startActivity(shareIntent);
      callbackContext.success();
    // } catch(Error e) {
    //   callbackContext.error(e.getMessage());
    // }
  }
}
