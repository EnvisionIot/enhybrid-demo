package com.envisioncn.cordova.hybridInit;

import com.envisioncn.cordova.shareddata.EnvAppData;
import android.app.Application;
import com.envisioncn.mobile.hybrid.router.EnvRouterHelper;
import android.content.res.Configuration;

// IMPORT START





// IMPORT END

public class EnvApplication extends Application {
    public EnvApplication() {
    }

    public void onCreate() {
        super.onCreate();
        EnvAppData.create(this);
        EnvRouterHelper.setUpRoutes(this.getApplicationContext());
        // ONCREATE START





        // ONCREATE END
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        // ONCONFIGURATIONCHANGED START





        // ONCONFIGURATIONCHANGED END
    }
}
    