package com.envisioncn.cordova.webContainer;

import android.content.Intent;
import android.support.v4.app.Fragment;

import org.apache.cordova.CordovaInterfaceImpl;
import org.apache.cordova.CordovaPlugin;

/**
 * 为CordovaFragment服务
 * <p>
 * Created by Xu Chao on 16/10/25
 */

public class FragmentCordovaInterfaceImpl extends CordovaInterfaceImpl {

    private Fragment fragment;

    public FragmentCordovaInterfaceImpl(Fragment fragment) {
        super(fragment.getActivity());
        this.fragment = fragment;
    }

    @Override
    public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {
        setActivityResultCallback(command);
        try {
            fragment.startActivityForResult(intent, requestCode);
        } catch (RuntimeException e) { // E.g.: ActivityNotFoundException
            activityResultCallback = null;
            throw e;
        }
    }
}
