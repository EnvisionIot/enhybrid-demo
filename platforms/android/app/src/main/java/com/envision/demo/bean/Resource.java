package com.envision.demo.bean;

import java.util.List;

public class Resource {
    private List<MenuItem> menus;
    private List<MenuItem> permissions;

    public Resource() {
    }

    public Resource(List<MenuItem> menus, List permissions) {
        this.menus = menus;
        this.permissions = permissions;
    }

    public List<MenuItem> getMenus() {
        return menus;
    }

    public void setMenus(List<MenuItem> menus) {
        this.menus = menus;
    }

    public List getPermissions() {
        return permissions;
    }

    public void setPermissions(List permissions) {
        this.permissions = permissions;
    }
}
