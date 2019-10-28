package com.envision.demo.login;
import android.content.SharedPreferences;
import android.text.TextUtils;

import com.envision.demo.EnvService;
import com.envision.demo.MyApplication;
import com.envision.demo.R;
import com.envision.demo.UserModel;
import com.envision.demo.bean.EnvResponse;
import com.envision.demo.bean.LoginUser;
import com.envision.demo.bean.User;
import com.envision.demo.bean.UserEnvironment;
import com.envision.demo.util.LogUtil;
import com.envisioncn.mobile.hybrid.router.EnvRouterHelper;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginPresenter implements LoginContract.Presenter {
    public static final String TAG = LoginPresenter.class.getSimpleName();

    private final LoginContract.View mView;
    private final UserModel mUserModel;

    private List<UserEnvironment> mEnvironmentOptions = new ArrayList<UserEnvironment>();

    private int mEnvironmentOption = 0;
    private boolean isPasswordVisible = false;

    private SharedPreferences sp;



    private Callback<EnvResponse<User>> mLoginCallback = new Callback<EnvResponse<User>>() {
        @Override
        public void onResponse(Call<EnvResponse<User>> call, Response<EnvResponse<User>> response) {
            LogUtil.d(TAG, "login code: " + response.code() + ", message: " +
                response.message());
            mView.hideLogging();
            EnvResponse<User> res = response.body();
            if (res.getCode().equals("200")) {
                saveUserInfo(res.getData(), mEnvironmentOptions.get(mEnvironmentOption));
                EnvRouterHelper.open("/demo/index.html");

            } else {
                mView.showLoginError(mView.getResources().getString(R.string.error_login), res.getMessage());
            }
        }

        @Override
        public void onFailure(Call<EnvResponse<User>> call, Throwable t) {
            LogUtil.d(TAG, "login call executed: " + call.isExecuted() + ", url: " +
                call.request().url());
            mView.hideLogging();
            LogUtil.i(TAG, t.getMessage());
            mView.showLoginError(mView.getResources().getString(R.string.error_login), mView.getResources().getString
                (R.string.error_login_network));
        }
    };


    public LoginPresenter(LoginContract.View view, UserModel userModel) {
        mView = view;
        mUserModel = userModel;
    }

    @Override
    public void start() {
        mView.setPasswordVisible(isPasswordVisible);
        initOptions();
        mView.setEnvironment(mEnvironmentOptions.get(mEnvironmentOption).getPickerViewText());

    }

    @Override
    public void changePasswordVisible() {
        isPasswordVisible = !isPasswordVisible;
        mView.setPasswordVisible(isPasswordVisible);
    }

    @Override
    public void showEnvironmentPickerView() {
        mView.showEnvironmentPickerView(mEnvironmentOptions, mEnvironmentOption);
    }

    @Override
    public void selectEnvironment(int option) {
        mEnvironmentOption = option;
        mView.setEnvironment(mEnvironmentOptions.get(mEnvironmentOption).getPickerViewText());
    }

    @Override
    public void login() {
        String username = mView.getUsername();
        String password = mView.getPassword();
        if (validate(username, password)) {
            //重新输入用户名密码后，先执行注销操作，防止从特殊路径进入登录页面后（忘记密码），没有执行注销操作导致缓存之前用户的信息
//            EnvApplication.getInstance().logout();
            doLogin(username, password);
        }
    }

    private void initOptions() {
        String[] environments = mView.getResources().getStringArray(R.array.title_environments_array);
        for (String envi : environments) {
            String[] str = envi.split("=");
            mEnvironmentOptions.add(new UserEnvironment(str[0].trim(), str[1].trim()));
        }

        String environment = mUserModel.getUserEnvironment();
        for (int i = 0; i < mEnvironmentOptions.size(); i++) {
            if (environment.equals(mEnvironmentOptions.get(i).getEnviroment())) {
                mEnvironmentOption = i;
                break;
            }
        }

    }

    private boolean validate(String username, String password) {
        if (TextUtils.isEmpty(username)) {
            mView.shakeUsernameEt();
            return false;
        }
        if (TextUtils.isEmpty(password)) {
            mView.shakePasswordEt();
            return false;
        }
        return true;
    }

    private void doLogin(String username, String password) {
        String baseUrl = mEnvironmentOptions.get(mEnvironmentOption).getUrl();
        MyApplication.BASE_URL = baseUrl;

        LoginUser user = new LoginUser(username, password);

        mView.showLogging();
        EnvService service = new EnvService.Builder(baseUrl).create();
        Call<EnvResponse<User>> call = service.login(user);
        call.enqueue(mLoginCallback);
    }

    private void saveUserInfo(User user, UserEnvironment environment) {
        mUserModel.setUser(user);
        mUserModel.setUserSignIn(true);
        mUserModel.setUserEnvironment(environment.getEnviroment());
        mUserModel.setBaseUrl(environment.getUrl());
        MyApplication.ENVIRONMENT_ID = mEnvironmentOption + "";
    }
}
