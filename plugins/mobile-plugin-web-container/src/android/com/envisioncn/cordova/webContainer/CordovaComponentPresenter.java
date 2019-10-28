package com.envisioncn.cordova.webContainer;

import android.os.Bundle;

public interface CordovaComponentPresenter {
    // 生命周期
    void onCreated(Bundle bundle);

    void initApperance();

    String getPageName();

    void loadWebContent();

    /**
     * webview生命周期
     */
    void onPageStarted();

    void onReceivedError();

    void onPageFinished();

}
