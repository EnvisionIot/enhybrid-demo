${package}

import android.app.Activity;
import android.os.Bundle;

import com.envisioncn.mobile.hybrid.router.EnvRouterHelper;

public class SplashActivity extends Activity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        EnvRouterHelper.open("");
    }
}