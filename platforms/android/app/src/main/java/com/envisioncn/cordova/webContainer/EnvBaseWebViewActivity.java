package com.envisioncn.cordova.webContainer;

import android.os.Bundle;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;

import com.envisioncn.mobile.hybrid.util.JsonUtil;
import com.envision.demo.R;

import org.apache.cordova.CordovaActivity;

// IMPORT START


// IMPORT END

/**
 * 用于后续扩展的CordovaActivity基类，抽象实现了一些基本功能
 */
public abstract class EnvBaseWebViewActivity extends CordovaActivity implements
    CordovaComponentView {

    public static boolean isNativeInteractionEnabled = true;

    private CordovaComponentPresenter mCordovaComponentPresenter = null;

    protected abstract void onActivityCreate();

    @Override
    public void loadUrl(String url) {
        // ADD COOKIES START


        // ADD COOKIES END
        super.loadUrl(url);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        onActivityCreate();
        mCordovaComponentPresenter = getCordovaComponentPresenter();
        mCordovaComponentPresenter.onCreated(getIntent().getExtras());
        postEventToJs("viewOnCreate", null);

    }

    public CordovaComponentPresenter getCordovaComponentPresenter() {
        if (mCordovaComponentPresenter != null) {
            return mCordovaComponentPresenter;
        }
        return new CordovaComponentPresenterImpl(this);
    }

    @Override
    public void setContentView(View view) {
        LinearLayout linearLayout = ((LinearLayout) findViewById(R.id.env_container));
        if (null != linearLayout) {
            linearLayout.addView(view);
        }
    }
    
    @Override
    public void onStart() {
        super.onStart();
        postEventToJs("viewOnStart", null);
    }

    @Override
    public void onResume() {
        super.onResume();
        postEventToJs("viewOnResume", null);
    }

    @Override
    public void onPause() {
        super.onPause();
        postEventToJs("viewOnPause", null);

    }

    @Override
    public void onStop() {
        super.onStop();
        postEventToJs("viewOnStop", null);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        postEventToJs("viewOnDestroy", null);

    }

    /**
     * 拦截物理按键的响应，当isNativeInteractionEnabled为false时，
     * Activity将不再响应按键事件，这里返回的值没有逻辑意义，仅用来
     * 阻止系统处理按键事件，所以true，false均可。
     *
     * @param event
     * @return
     */
    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (!isNativeInteractionEnabled) {
            return false;
        }
        return super.dispatchKeyEvent(event);
    }

    /**
     * 拦截触摸事件的响应，当isNativeInteractionEnabled为false时，
     * Activity将不再响应触摸事件，这里返回的值没有逻辑意义，仅用来
     * 阻止系统处理触摸事件，所以true，false均可。
     *
     * @param ev
     * @return
     */
    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (!isNativeInteractionEnabled) {
            return false;
        }
        return super.dispatchTouchEvent(ev);
    }

    @Override
    public void postEventToJs(String type) {
        this.postEventToJs(type, "");
    }

    @Override
    public void postEventToJs(String type, Object data) {
        this.appView.loadUrl(String.format(
            "javascript:document.dispatchEvent(new CustomEvent(\"%s\", {detail : %s}));", type,
            JsonUtil.getJsonByObj(data)));
    }

    /**
     * 根据字符串key, 读取字符串
     *
     * @param key String类型的字符串key
     * @return
     */
    @Override
    public String getStringFromRes(String key) {
        try {
            return getResources().getString(getResources().getIdentifier(key, "string",
                                                                         getPackageName()));
        } catch (Exception e) {
            return key;
        }
    }

    /**
     * 加载url
     *
     * @param url
     */
    @Override
    public void loadWebContent(String url) {
        loadUrl(url);
    }

    @Override
    public void backToPrevious() {
        this.finish();
    }

    @Override
    public void onBackPressed() {
        this.backToPrevious();
    }

    @Override
    public Object onMessage(String id, Object data) {
        //监听页面加载状态
        if (id != null && mCordovaComponentPresenter != null) {
            if (id.equalsIgnoreCase("onPageFinished")) {
                mCordovaComponentPresenter.onPageFinished();
            } else if (id.equalsIgnoreCase("onPageStarted")) {
                mCordovaComponentPresenter.onPageStarted();
            } else if (id.equalsIgnoreCase("onReceivedError")) {
                mCordovaComponentPresenter.onReceivedError();
            }
        }
        return super.onMessage(id, data);
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        invalidateOptionsMenu();
        return super.onPrepareOptionsMenu(menu);
    }
}
