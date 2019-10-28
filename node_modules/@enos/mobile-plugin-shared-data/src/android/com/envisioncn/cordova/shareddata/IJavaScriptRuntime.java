package com.envisioncn.cordova.shareddata;

import android.webkit.ValueCallback;

/**
 * Created by chao.xu on 16/3/18.
 */
public interface IJavaScriptRuntime {
    void evaluateJavascript(String script, ValueCallback<String> resultCallback);

    void terminate();
}
