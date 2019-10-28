package com.envision.demo;

import android.content.Context;
import android.content.SharedPreferences;

import com.envision.demo.bean.SetSession;
import com.envision.demo.bean.User;

public class UserModel {
    private static final String SP_NAME = "sp_user_info";

    private static final String KEY_SHOW_MENU_GUIDE = "show_menu_guide";

    private static final String KEY_USER_SIGN_IN = "user_sign_in";
    private static final String KEY_USERNAME = "username";
    private static final String KEY_USER_PASSWORD = "user_password";
    private static final String KEY_USER_ENVIRONMENT = "user_environment";
    private static final String KEY_BASE_URL = "base_url";
    private static final String KEY_USER_AUTH_WAY = "user_auth_way";
    private static final String KEY_USER_ID = "user_id";
    private static final String KEY_APP_ID = "app_id";
    private static final String KEY_ACCESS_TOKEN = "accessToken";
    private static final String KEY_REFRESH_TOKEN = "refresh_token";

    private static final String KEY_GLOBAL_ID = "global_id";
    private static final String KEY_GLOBAL_EXPIRY = "global_expiry";
    private static final String KEY_USER_ORGANIZATION = "organizations";

    private SharedPreferences sp;

    public UserModel(Context context) {
        sp = context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
    }

    public boolean showMenuGuide() {
        return sp.getBoolean(KEY_SHOW_MENU_GUIDE, true);
    }

    public void setShowMenuGuide(boolean show) {
        sp.edit().putBoolean(KEY_SHOW_MENU_GUIDE, show).apply();
    }


    public void setUserSignIn(boolean signIn) {
        sp.edit().putBoolean(KEY_USER_SIGN_IN, signIn).apply();
    }

    public String getUserEnvironment() {
        return sp.getString(KEY_USER_ENVIRONMENT, "中国");
    }

    public void setUserEnvironment(String environment) {
        sp.edit().putString(KEY_USER_ENVIRONMENT, environment).apply();
    }

    public String getBaseUrl() {
        return sp.getString(KEY_BASE_URL, "https://beta-app-portal-cn4.eniot.io");
    }

    public void setBaseUrl(String baseUrl) {
        sp.edit().putString(KEY_BASE_URL, baseUrl).apply();
    }

    public String getUsername() {
        return sp.getString(KEY_USERNAME, null);
    }


    public void setUser(User user) {
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(KEY_USERNAME, user.getUser().getName());
        editor.putString(KEY_USER_ID, user.getUser().getId());
        editor.putString(KEY_ACCESS_TOKEN, user.getAccessToken()).apply();
    }

    public void setSessionInfo(SetSession session) {
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(KEY_USERNAME, session.getUserName());
        editor.putString(KEY_USER_ID, session.getUserId());
        editor.putString(KEY_REFRESH_TOKEN, session.getRefreshToken()).apply();
        editor.putString(KEY_ACCESS_TOKEN, session.getAccessToken()).apply();
    }

    public String getAccessToken() {
        return sp.getString(KEY_ACCESS_TOKEN, "");
    }



    public String getGlobalId() {
        return sp.getString(KEY_GLOBAL_ID, "");
    }


    public void setGlobal(String globalId, long globalExpiry) {
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(KEY_GLOBAL_ID, globalId);
        editor.putLong(KEY_GLOBAL_EXPIRY, globalExpiry).apply();
    }


}
