package com.envision.demo.login;

import android.content.res.Resources;

import com.envision.demo.bean.UserEnvironment;

import java.util.List;

public interface LoginContract {

    interface View {

        Resources getResources();

        void setUsername(CharSequence username);

        void setPassword(CharSequence password);

        String getUsername();

        String getPassword();

        void shakeUsernameEt();

        void shakePasswordEt();

        void setPasswordVisible(boolean visible);

        void showEnvironmentPickerView(List<UserEnvironment> options, int selection);

        void setEnvironment(String environment);

        void showLogging();

        void hideLogging();

        void showLoginError(String message, String detail);

        void showLoginSuccess();

        String getCurrentVersion();

    }

    interface Presenter {

        void start();

        void changePasswordVisible();

        void showEnvironmentPickerView();

        void selectEnvironment(int option);

        void login();

    }
}
