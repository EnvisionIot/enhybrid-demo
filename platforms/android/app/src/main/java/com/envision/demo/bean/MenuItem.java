package com.envision.demo.bean;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;
import java.util.List;

public class MenuItem {

    private String id;
    private String code;
    private String url;
    private String name;
    private String displayOrder;
    private String parentId;
    private List<MenuItem> children = new ArrayList<MenuItem>();

    /** 菜单类型，group、item */
    @JsonIgnore
    private String type = "item";

    /** 菜单是否被选中 */
    @JsonIgnore
    private boolean selected = false;

    public MenuItem() {}

    public MenuItem(String id, String code, String url, String name, String displayOrder, String parentId, List<MenuItem> children) {
        this.id = id;
        this.code = code;
        this.url = url;
        this.name = name;
        this.displayOrder = displayOrder;
        this.parentId = parentId;
        this.children = children;
    }

    public MenuItem(String id, String code, String url, String name, String displayOrder, String parentId, List<MenuItem> children, String type) {
        this.id = id;
        this.code = code;
        this.url = url;
        this.name = name;
        this.displayOrder = displayOrder;
        this.parentId = parentId;
        this.children = children;
        this.type = type;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(String displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public List<MenuItem> getChildren() {
        return children;
    }

    public void setChildren(List<MenuItem> children) {
        this.children = children;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }
}
