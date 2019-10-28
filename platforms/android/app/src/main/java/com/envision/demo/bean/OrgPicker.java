package com.envision.demo.bean;

import com.envision.demo.widget.PickerView;

public class OrgPicker implements PickerView.IPickerViewOption {
    private String name;
    private String id;

    public OrgPicker(String name, String id) {
        this.name = name;
        this.id = id;
    }

    public OrgPicker() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Override
    public String getPickerViewText() {
        return name;
    }
}
