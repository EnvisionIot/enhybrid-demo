package com.envision.demo.util;

import android.content.res.Resources;


import com.envision.demo.MyApplication;
import com.envisioncn.cordova.shareddata.EnvAppData;
import com.envisioncn.cordova.shareddata.IJSValueCallback;

import java.util.Locale;

public class LanguageUtil {

    public static String getLang() {
        return getLang(MyApplication.APP_CONTEXT.getResources());
    }

    public static String getLang(Resources resources) {
        Locale locale = resources.getConfiguration().locale;
        final String languageString = locale.getLanguage();
        return languageString.contains("zh") ? "zh-CN" : "en-US";
    }
}
