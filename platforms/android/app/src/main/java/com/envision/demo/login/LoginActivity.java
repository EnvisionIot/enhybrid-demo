package com.envision.demo.login;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.constraint.ConstraintLayout;
import android.support.v7.app.AppCompatActivity;
import android.text.InputType;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.LinearInterpolator;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.envision.demo.MyApplication;
import com.envision.demo.R;
import com.envision.demo.UserModel;
import com.envision.demo.bean.OrgPicker;
import com.envision.demo.bean.UserEnvironment;
import com.envision.demo.util.MessageUtil;
import com.envision.demo.widget.PickerView;
import com.envisioncn.mobile.hybrid.router.EnvRouterHelper;
import com.gyf.barlibrary.ImmersionBar;

import java.util.List;


public class LoginActivity extends AppCompatActivity implements LoginContract.View {

    private LoginContract.Presenter mPresenter;

    private EditText etUsername;
    private EditText etPassword;
    private TextView tvPasswordEye;
    private TextView tvEnvironment;
    private TextView tvAuthWay;

    private TextView tvArrowEnvironment;
    private TextView tvArrowAuthWay;
    private Animation shakeAnim;

    private PickerView<UserEnvironment> pvEnvironment;
    private PickerView<OrgPicker> orgPickerView;

    private ViewGroup mConstraintLayout;

    private boolean isLogging = false;
    private View mLoadingView;
    private ObjectAnimator mLoadingAnim;

    private View eivPasswordFork;
    private View eivUsernameFork;

    private Button btnLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        mLoadingView = findViewById(R.id.iv_loading);
        etUsername = findViewById(R.id.et_username);
        etPassword = findViewById(R.id.et_password);
        tvPasswordEye = findViewById(R.id.eiv_password_eye);
        tvEnvironment = findViewById(R.id.tv_environment);
        tvArrowEnvironment = findViewById(R.id.arrow_environment);
        mConstraintLayout = findViewById(R.id.ll_fields);
        eivPasswordFork = findViewById(R.id.eiv_password_fork);
        eivUsernameFork = findViewById(R.id.eiv_username_fork);
        btnLogin = findViewById(R.id.btn_login);


        etUsername.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                eivUsernameFork.setVisibility(hasFocus ? View.VISIBLE : View.INVISIBLE);
            }
        });

        etPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                eivPasswordFork.setVisibility(hasFocus ? View.VISIBLE : View.INVISIBLE);
            }
        });
        eivPasswordFork.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                etPassword.setText("");
            }
        });
        eivUsernameFork.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                etUsername.setText("");
            }
        });
        shakeAnim = AnimationUtils.loadAnimation(this, R.anim.shake);

        mPresenter = new LoginPresenter(this, new UserModel(this));

        initListener();
        mPresenter.start();
        addOnSoftKeyBoardVisibleListener();
        ImmersionBar.with(this)
                .statusBarDarkFont(false)
                .init();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mLoadingAnim != null && mLoadingAnim.isRunning())
            mLoadingAnim.end();
    }

    private void initListener() {
        tvEnvironment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPresenter.showEnvironmentPickerView();
            }
        });
        tvPasswordEye.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPresenter.changePasswordVisible();
            }
        });
        findViewById(R.id.btn_login).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPresenter.login();
            }
        });
    }

    @Override
    public void setUsername(CharSequence username) {
        etUsername.setText(username);
    }

    @Override
    public void setPassword(CharSequence password) {
        etPassword.setText(password);
    }

    @Override
    public String getUsername() {
        return etUsername.getText().toString().trim();
    }

    @Override
    public String getPassword() {
        return etPassword.getText().toString();
    }

    @Override
    public void shakeUsernameEt() {
        etUsername.startAnimation(shakeAnim);
    }

    @Override
    public void shakePasswordEt() {
        etPassword.startAnimation(shakeAnim);
    }

    @Override
    public void setPasswordVisible(boolean visible) {
        if (visible) {
            tvPasswordEye.setText("\ue907");
            etPassword.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
        } else {
            tvPasswordEye.setText("\ue906");
            etPassword.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        }
        etPassword.setTypeface(Typeface.DEFAULT);
        etPassword.setSelection(etPassword.getText().length());
    }

    @Override
    public void showEnvironmentPickerView(List<UserEnvironment> options, int selection) {
        hideKeyboard();
        if (pvEnvironment == null) {
            pvEnvironment = new PickerView<UserEnvironment>(this);
            pvEnvironment.setTitle(R.string.user_environment);
            pvEnvironment.setOptions(options);
            pvEnvironment.setSelectOption(selection);
            pvEnvironment.setOnDismissListener(new PickerView.OnDismissListener() {
                @Override
                public void onDismiss() {
                    tvArrowEnvironment.setText("\ue928");
                }
            });
            pvEnvironment.setOnItemClickListener(new PickerView.OnItemClickListener() {
                @Override
                public void onItemClick(int position) {
                    mPresenter.selectEnvironment(position);
                }
            });
        }
        tvArrowEnvironment.setText("\ue927");
        pvEnvironment.show();
    }

    @Override
    public void setEnvironment(String environment) {
        tvEnvironment.setText(environment);
    }

    @Override
    public void showLogging() {
        if (isLogging)
            return;
        mLoadingAnim = ObjectAnimator.ofFloat(mLoadingView, "rotation", 0.0F, 359.0F);
        mLoadingAnim.setRepeatCount(-1);
        mLoadingAnim.setDuration(2400);
        mLoadingAnim.setInterpolator(new LinearInterpolator());
        mLoadingView.setVisibility(View.VISIBLE);
        mLoadingAnim.start();
        btnLogin.setText("");
        isLogging = true;
    }

    @Override
    public void hideLogging() {
        if (!isLogging)
            return;
        mLoadingAnim.end();
        mLoadingView.setVisibility(View.GONE);
        isLogging = false;
        btnLogin.setText(getString(R.string.login));
    }

    @Override
    public void showLoginError(String message, String detail) {
        MessageUtil.error(this, message, detail);
    }

    @Override
    public void showLoginSuccess() {
//        TODO:需要改回来
        EnvRouterHelper.open(MyApplication.HOME_ROUTE);
        finish();
    }

    private void hideKeyboard() {
        InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        // 如果正在输入,则隐藏键盘
        if (inputManager.isAcceptingText()) {
            inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),
                InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    public String getCurrentVersion() {
        try {
            return getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 监听软键盘状态
     */
    private void addOnSoftKeyBoardVisibleListener() {
        final View decorView = getWindow().getDecorView();
        decorView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                Rect rect = new Rect();
                decorView.getWindowVisibleDisplayFrame(rect);
                boolean isKeyBoardOpen = (double) (rect.bottom - rect.top) / decorView.getHeight() < 0.8;
                ConstraintLayout.LayoutParams layoutParams = (ConstraintLayout.LayoutParams) mConstraintLayout.getLayoutParams();

                if(isKeyBoardOpen){
                    layoutParams.verticalBias = 0;
                }else{
                    layoutParams.verticalBias = (float) 0.3;
                }
                mConstraintLayout.setLayoutParams(layoutParams);
            }
        });
    }
}
