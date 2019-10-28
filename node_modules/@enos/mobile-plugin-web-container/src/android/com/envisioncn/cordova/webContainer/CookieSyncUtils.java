package com.envisioncn.cordova.webContainer;

import android.content.Context;
import android.os.Build;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;

public class CookieSyncUtils {

    public static void syncCookie(Context context, String url, String cookie) {
        if (cookie != null) {
            CookieSyncManager.createInstance(context);
            CookieManager.setAcceptFileSchemeCookies(true);
            CookieManager cookieManager = CookieManager.getInstance();
            cookieManager.setAcceptCookie(true);
            cookieManager.setCookie(url, cookie);
            if (Build.VERSION.SDK_INT < 21) {
                CookieSyncManager.getInstance().sync();
            } else {
                CookieManager.getInstance().flush();
            }
        }
    }
}
