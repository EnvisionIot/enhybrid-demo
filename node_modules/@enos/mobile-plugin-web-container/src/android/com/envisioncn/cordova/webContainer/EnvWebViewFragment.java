package com.envisioncn.cordova.webContainer;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.inputmethod.InputMethodManager;

import com.envisioncn.mobile.hybrid.util.JsonUtil;


/**
 * @author chao.xu
 * @date 2016/04/02
 */
public class EnvWebViewFragment extends EnvCordovaFragment implements CordovaComponentView {

    private CordovaComponentPresenter mCordovaComponentPresenter = null;

    @Override
    public void loadUrl(String url) {        
        // ADD COOKIES START
        // ADD COOKIES END
        super.loadUrl(url);
    }

    @Override
    public void setMenuVisibility(boolean menuVisible) {
        super.setMenuVisibility(menuVisible);
        if (menuVisible) {
            if (null != mCordovaComponentPresenter) {
                mCordovaComponentPresenter.initApperance();
            }
        }
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mCordovaComponentPresenter = getCordovaComponentPresenter();
        mCordovaComponentPresenter.onCreated(getArguments());
    }

    public CordovaComponentPresenter getCordovaComponentPresenter() {
        if (mCordovaComponentPresenter != null) {
            return mCordovaComponentPresenter;
        }
        return new CordovaComponentPresenterImpl(this);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        Log.d(TAG, this.getClass().getName() + "-onFragmentCreated");
    }

    @Override
    public Object getToolBar() {
        return ((CordovaComponentView) getActivity()).getToolBar();
    }

    @Override
    public void postEventToJs(String type) {
        this.postEventToJs(type, "");
    }

    @Override
    public void postEventToJs(String type, Object data) {
        this.appView.loadUrl(String.format(
            "javascript:document.dispatchEvent(new CustomEvent(\"%s\", {data : %s}));", type,
            JsonUtil.getJsonByObj(data)));
    }

    @Override
    public String getStringFromRes(String key) {
        try {
            return getResources().getString(getResources().getIdentifier(key, "string", getActivity().getPackageName()));
        } catch (Exception e) {
            return key;
        }
    }

    @Override
    public void loadWebContent(String url) {
        loadUrl(url);
    }

    @Override
    public void backToPrevious() {
        InputMethodManager inputManager = (InputMethodManager) this.getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        // 如果正在输入,则仅仅隐藏键盘
        if (inputManager.isAcceptingText()) {
            inputManager.hideSoftInputFromWindow(this.getActivity().getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }
        if (this.getActivity() != null) {
            this.getActivity().onBackPressed();
        }
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


}
