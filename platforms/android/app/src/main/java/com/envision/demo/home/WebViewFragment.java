package com.envision.demo.home;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.webkit.WebView;


import com.envision.demo.R;
import com.envisioncn.cordova.webContainer.EnvIconView;
import com.envisioncn.cordova.webContainer.EnvWebViewFragment;
import com.envisioncn.mobile.hybrid.router.Router;

import org.apache.cordova.LOG;
import org.json.JSONObject;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

public class WebViewFragment extends EnvWebViewFragment {

    private View.OnClickListener mLeftIconClickListener;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Toolbar toolbar = (Toolbar) getToolBar();
        View leftIconL = toolbar.findViewById(R.id.left_icon_corner);
        EnvIconView leftEnvIconViewL = toolbar.findViewById(R.id.left_icon_iv);
        leftEnvIconViewL.setText("\ue92d");
        if (leftIconL != null) {
            leftIconL.setOnClickListener(mLeftIconClickListener);
        }
    }

    public void setLeftIconClickListener(View.OnClickListener listener) {
        mLeftIconClickListener = listener;
    }

    @Override
    public void onPause() {
        super.onPause();
        LOG.d(TAG, "Paused the fragment.");
        if (this.appView != null) {
            // CB-9382 If there is an activity that started for result and main activity is waiting for callback
            // result, we shoudn't stop WebView Javascript timers, as activity for result might be using them
            boolean keepRunning = this.keepRunning;
            this.appView.handlePause(keepRunning);
        }
    }

    @Override
    public Object onMessage(String id, final Object data) {
        if (id != null) {
            if (id.equalsIgnoreCase("onPageFinished")) {
            } else if (id.equalsIgnoreCase("onPageStarted")) {
            } else if (id.equalsIgnoreCase("onReceivedError")) {
                loadWebContent(concatUrl("/mobile-hybrid-common-module/errorPage.html"));
            }
        }
        return super.onMessage(id, data);
    }

    private String concatUrl(String url){
        String rootUrl = Router.sharedRouter().getRootUrl();
        String tempPath = url.substring(0, url.indexOf("/", 1)) + File.separator + "bundles" + url.substring(url.indexOf("/", 1));
        String tempUrl = rootUrl + tempPath;
        return tempUrl;
    }


    public Object getToolBar() {
        return ((MainActivity) getActivity()).getToolBar();
    }

}
