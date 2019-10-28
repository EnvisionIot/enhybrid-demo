package com.envisioncn.cordova.log;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * LoggingPlugin
 * @author chao.xu
 * @date 2016-11-23
 */
public class LoggingPlugin extends CordovaPlugin{
    private static final String TAG = "LoggingPlugin";

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

        if (action.equals("log")) {
            this.log(data.getString(0), callbackContext);
        } else{
            return false;
        }
        // Only alert and confirm are async.
        return true;
    }


    private void log(String message, CallbackContext callbackContext){
        Log.i(TAG, message);
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }

}
