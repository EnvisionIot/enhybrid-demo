package com.envision.demo.bean;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class User {


    private List<Org> organizations;
    private UserInfo user;

    public boolean getIsSuperAdmin() {
        return isSuperAdmin;
    }

    public void setIsSuperAdmin(boolean superAdmin) {
        isSuperAdmin = superAdmin;
    }

    private boolean isSuperAdmin;
    private String accessToken;

    public User() {
    }

    public List<Org> getOrganizations() {
        return organizations;
    }

    public void setOrganizations(List<Org> organizations) {
        this.organizations = organizations;
    }

    public UserInfo getUser() {
        return user;
    }

    public void setUser(UserInfo user) {
        this.user = user;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public User(List<Org> organizations, UserInfo user, String accessToken, boolean isSuperAdmin) {
        this.organizations = organizations;
        this.user = user;
        this.isSuperAdmin = isSuperAdmin;
        this.accessToken = accessToken;
    }
}
