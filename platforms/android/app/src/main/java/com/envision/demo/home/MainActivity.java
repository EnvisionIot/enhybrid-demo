package com.envision.demo.home;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.Toolbar;
import android.view.View;
import com.envision.demo.MyApplication;
import com.envision.demo.R;
import com.envision.demo.UserModel;
import com.envision.demo.base.BaseActivity;
import com.envision.demo.login.LoginActivity;
import com.envisioncn.mobile.hybrid.EnvConstants;
import com.envisioncn.mobile.hybrid.router.EnvRouterHelper;
import com.gyf.barlibrary.ImmersionBar;
import java.net.URLEncoder;


import static com.envisioncn.mobile.hybrid.EnvConstants.ROUTER_KEY_LEFT_ICON;
import static com.envisioncn.mobile.hybrid.EnvConstants.ROUTER_KEY_REMOTE_SERVER;


public class MainActivity extends BaseActivity {

    private Toolbar toolbar;

    private UserModel mUserModel;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        toolbar = findViewById(R.id.toolbar_navigation);
        toolbar.setBackgroundColor(getResources().getColor(R.color.white_navi_bg_color));
        mUserModel = new UserModel(this);
        changeModule(getIntent().getExtras());
        ImmersionBar.with(this)
                .statusBarColor(R.color.status_bar_color)
                .statusBarDarkFont(false)
                .init();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ImmersionBar.with(this).destroy();
    }

    public Object getToolBar() {
        return toolbar;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        boolean ifExit;
        setIntent(intent);
        Bundle bundle = getIntent().getExtras();
        if (null != bundle) {
            ifExit = bundle.getBoolean("exit");
            if (ifExit) {
                startActivity(new Intent(this, LoginActivity.class));
                finish();
            }else{
                changeModule(bundle);
            }
        }
    }

    private void changeModule(Bundle bundle) {
        String routeServer = bundle.getString(EnvConstants.ROUTER_KEY_PERFIX + ROUTER_KEY_REMOTE_SERVER);
        if(routeServer != null && routeServer.equals("http://${solarBaseServer}")){
            bundle.putString(EnvConstants.ROUTER_KEY_PERFIX + ROUTER_KEY_REMOTE_SERVER, MyApplication.BASE_URL);
            ImmersionBar.with(this)
                    .statusBarColor(R.color.solar_status_bar_color)
                    .statusBarDarkFont(false)
                    .init();
        }else{
            ImmersionBar.with(this)
                    .statusBarColor(R.color.status_bar_color)
                    .statusBarDarkFont(true)
                    .init();
        }
        WebViewFragment webViewFragment = new WebViewFragment();
        webViewFragment.setLeftIconClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String url = getIntent().getExtras().get("route_pfx_url") != null ? getIntent().getExtras().get("route_pfx_url").toString() : "";
                try {
                    EnvRouterHelper.open("/menus?cur_menus=" + URLEncoder.encode(url, "utf-8"));
                } catch (Exception e) {
                }
            }
        });
        bundle.putString(EnvConstants.ROUTER_KEY_PERFIX + ROUTER_KEY_LEFT_ICON, "\ue92d");
        webViewFragment.setArguments(bundle);
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.replace(R.id.env_container, webViewFragment);
        transaction.commit();
    }
}
