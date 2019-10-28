package com.envision.demo.bean;


import com.envision.demo.widget.PickerView;

public class UserEnvironment implements PickerView.IPickerViewOption {

    private String enviroment;
    private String url;

    public UserEnvironment(String enviroment, String url) {
        this.enviroment = enviroment;
        this.url = url;
    }

    public String getEnviroment() {
        return enviroment;
    }

    public void setEnviroment(String enviroment) {
        this.enviroment = enviroment;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String getPickerViewText() {
        return enviroment;
    }
}
