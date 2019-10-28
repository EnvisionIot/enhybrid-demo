package com.envision.demo;

import android.content.Context;

import com.envision.demo.login.LoginActivity;
import com.envisioncn.cordova.hybridInit.EnvApplication;
import com.envisioncn.mobile.hybrid.router.EnvRouterHelper;

public class MyApplication extends EnvApplication {
    public static Context APP_CONTEXT = null;

    public static String BASE_URL = "";
    public static String GLOBAL_ID = "";
    public static String ENVIRONMENT_ID = "";
    public static String HOME_ROUTE = "/demo/index.html";
    public static String ORG_ID = "";
    private static MyApplication myApplication = null;

    @Override
    public void onCreate() {
        super.onCreate();
        EnvRouterHelper.map("/login", LoginActivity.class);
        APP_CONTEXT = this.getApplicationContext();
        UserModel userModel = new UserModel(APP_CONTEXT);
        BASE_URL = userModel.getBaseUrl();
        GLOBAL_ID = userModel.getGlobalId();
        myApplication = this;

    }

    public static MyApplication getInstance(){
        return myApplication;
    }

}
