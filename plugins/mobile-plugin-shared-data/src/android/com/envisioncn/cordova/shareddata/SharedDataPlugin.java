package com.envisioncn.cordova.shareddata;


import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by zihan.chen on 16/3/3.
 */
public class SharedDataPlugin extends CordovaPlugin {
    private static final String TAG = "SharedDataPlugin";

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
        if(action.equals("isInitialized")) {
            this.isInitialized(callbackContext);
        }else if(action.equals("initialize")) {
            this.initialize(data.get(0), callbackContext);
        }
        else if (action.equals("removeItem")) {
            this.removeItem(data.getString(0), callbackContext);
        }
        else if (action.equals("setItem")) {
            this.setItem(data.getString(0), data.get(1), callbackContext);
        }
        else if (action.equals("getItem")) {
            this.getItem(data.getString(0), callbackContext);
        }
        else if (action.equals("getPersistentItem")) {
            this.getPersistentItem(data.getString(0), callbackContext);
        }
        else if (action.equals("savePersistentItem")) {
            this.savePersistentItem(data.getString(0), data.getString(1), callbackContext);
        }
        else if (action.equals("removePersistentItem")) {
            this.removePersistentItem(data.getString(0), callbackContext);
        }
        else if (action.equals("getNamespaceItem")) {
            this.getNamespaceItem(data.getString(0), data.getString(1), callbackContext);
        }
        else if (action.equals("saveNamespaceItem")) {
            this.saveNamespaceItem(data.getString(0), data.getString(1), data.getString(2), callbackContext);
        }
        else if (action.equals("removeNamespaceItem")) {
            this.removeNamespaceItem(data.getString(0), data.getString(1), callbackContext);
        }
        else if (action.equals("removeNamespaceAllItem")) {
            this.removeNamespaceAllItem(data.getString(0), callbackContext);
        }
        return true;
    }

    private void isInitialized(CallbackContext callbackContext){
        boolean initialized = EnvAppData.getInstance().isInitialized();
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, initialized));
    }

    private void initialize(Object rootObject, final CallbackContext callbackContext){
        if(rootObject instanceof JSONObject){
            EnvAppData.getInstance().initialize((JSONObject)rootObject, new IJSValueCallback() {
                @Override
                public void onResolveValue(Object value) {
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
                }
            });
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "invalid argument"));
        }
    }

    private void setItem(String key, Object value, final CallbackContext callbackContext){
        EnvAppData.getInstance().setItem(key, value, new IJSValueCallback() {
            @Override
            public void onResolveValue(Object value) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }

    private void getItem(final String key, final CallbackContext callbackContext){

        EnvAppData.getInstance().getItem(key, new IJSValueCallback() {
            @Override
            public void onResolveValue(final Object value) {
                if(value instanceof String){
                    callbackContext.success((String)value);
                }else if(value instanceof JSONObject){
                    callbackContext.success((JSONObject)value);
                }else if(value instanceof JSONArray){
                    callbackContext.success((JSONArray)value);
                }else if(value instanceof Boolean){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Boolean) value).booleanValue()));
                }else if(value instanceof Integer){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Integer)value).intValue()));
                }else if(value instanceof Float){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Float)value).floatValue()));
                }else{
                    Log.e(TAG, "@@ not fount key : " + key);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
                }
            }
        });

    }

    private void removeItem(String key, final CallbackContext callbackContext){
        EnvAppData.getInstance().removeItem(key, new IJSValueCallback() {
            @Override
            public void onResolveValue(Object value) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }



    private void getPersistentItem(final String key, final CallbackContext callbackContext){
        EnvAppData.getInstance().getPersistentItem(key, new IJSValueCallback() {
            @Override
            public void onResolveValue(final Object value) {
                if(value instanceof String){
                    callbackContext.success((String)value);
                }else if(value instanceof Boolean){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Boolean) value).booleanValue()));
                }else if(value instanceof Integer){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Integer)value).intValue()));
                }else if(value instanceof Long){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Long)value).intValue()));
                }else if(value instanceof Float){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Float)value).floatValue()));
                }else{
                    Log.e(TAG, "@@ not fount key : " + key);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
                }
            }
        });
    }



    private void savePersistentItem(String key, Object value, final CallbackContext callbackContext){
        EnvAppData.getInstance().savePersistentItem(key, value, new IJSValueCallback() {
            @Override
            public void onResolveValue(Object value) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }



    private void removePersistentItem(String key, final CallbackContext callbackContext){
        EnvAppData.getInstance().removePersistentItem(key, new IJSValueCallback() {
            @Override
            public void onResolveValue(Object value) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }

    private void getNamespaceItem(String namespace, final String key, final CallbackContext callbackContext){
        EnvAppData.getInstance().getNameSpaceItem(namespace, key, new IJSValueCallback() {
            @Override
            public void onResolveValue(final Object value) {
                if(value instanceof String){
                    callbackContext.success((String)value);
                }else if(value instanceof Boolean){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Boolean) value).booleanValue()));
                }else if(value instanceof Integer){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Integer)value).intValue()));
                }else if(value instanceof Long){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Long)value).intValue()));
                }else if(value instanceof Float){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ((Float)value).floatValue()));
                }else{
                    Log.e(TAG, "@@ not fount key : " + key);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
                }
            }
        });
    }



    private void saveNamespaceItem(String namespace, String key, Object value, final CallbackContext callbackContext){
        EnvAppData.getInstance().saveNameSpaceItem(namespace, key, value, new IJSValueCallback() {
            @Override
            public void onResolveValue(Object value) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }


    private void removeNamespaceItem(String namespace, String key, final CallbackContext callbackContext){
        EnvAppData.getInstance().removeNameSpaceItem(namespace, key, new IJSValueCallback() {
            @Override
            public void onResolveValue(Object value) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }


    private void removeNamespaceAllItem(String namespace, final CallbackContext callbackContext){
        EnvAppData.getInstance().removeNameSpaceAllItem(namespace, new IJSValueCallback() {
            @Override
            public void onResolveValue(Object value) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }

}
