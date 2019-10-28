package com.envisioncn.cordova.router;

import android.app.Activity;

import com.envisioncn.mobile.hybrid.router.EnvRouterHelper;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * Created by zihan.chen on 16/3/3.
 */
public class ShellRouterPlugin extends CordovaPlugin {
    private static final String TAG = "ShellRouterPlugin";

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action            The action to execute.
     * @param data              JSONArray of arguments for the plugin.
     * @param callbackContext   The callback context used when calling back into JavaScript.
     * @return                  True when the action was valid, false otherwise.
     */
    @Override
    public boolean execute(String action, JSONArray data,
                           CallbackContext callbackContext) throws JSONException {
        /*
    	 * Don't run any of these if the current activity is finishing
    	 * in order to avoid android.view.WindowManager$BadTokenException
    	 * crashing the app. Just return true here since false should only
    	 * be returned in the event of an invalid action.
    	 */
        if(this.cordova.getActivity().isFinishing()) return true;

        if (action.equals("replaceState")) {
            this.replaceState(data.getString(0), callbackContext);
        }
        else if (action.equals("pushState")) {
            this.pushState(data.getString(0), callbackContext);
        }
        else if (action.equals("goBack")) {
            this.goBack(callbackContext);
        }
        else if (action.equals("logout")) {
            this.logout(callbackContext);
        }
        else if (action.equals("action")) {
            this.action(data, callbackContext);
        }
        // Only alert and confirm are async.
        callbackContext.success();
        return true;
    }

    private void replaceState(String path, CallbackContext callbackContext){
        if(path != null && path.length()>0 ){
            EnvRouterHelper.open(path);
            cordova.getActivity().finish();
        }
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    private void pushState(String path, CallbackContext callbackContext){
        if(path != null && path.length()>0){
            //WLog.w(TAG, "@@@ pushState " + path);
           EnvRouterHelper.open(path);
        }
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    private void goBack(CallbackContext callbackContext){
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                activity.onBackPressed();
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

     private void logout(CallbackContext callbackContext){
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                //TODO logout逻辑
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

    private void action(JSONArray data, CallbackContext callbackContext){
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // TODO 自定义action处理逻辑
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }
}
