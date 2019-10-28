package com.envisioncn.cordova.shareddata;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.webkit.ValueCallback;
import android.webkit.WebView;


/**
 * Created by Xu Chao on 16/6/25.
 */
public class WebKitJSRunner implements IJavaScriptRuntime {
    private WebView webView = null;

    public WebKitJSRunner(final Context context) {
        if (webView == null) {
            ThreadUtils.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    webView = new WebView(context);
                    webView.getSettings().setJavaScriptEnabled(true);
                    webView.loadUrl("file:///android_asset/www/polyfill/envcontext.html");
                }
            });
        }

    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    public void evaluateJavascript(final String script, final ValueCallback<String> resultCallback) {
        //此处不能使用 WebView.post()。WebView.post 会将任务发送到当前线程关联的一个队列中保存，而当WebView
        // 没有attach到主窗口时（如仅作为runtime使用），这个队列中的任务是不会被发送到UI线程的MessageQueue中的。
        // 所以这里手动创建一个关联到UI线程的Handler，处理任务发送。
        ThreadUtils.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                webView.evaluateJavascript(script, resultCallback);

            }
        });
    }

    public void terminate() {
        if (webView != null) {
            ThreadUtils.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    webView.destroy();
                }
            });
        }
    }

}
