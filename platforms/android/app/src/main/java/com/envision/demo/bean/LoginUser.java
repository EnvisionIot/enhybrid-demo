package com.envision.demo.bean;

public class LoginUser {

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    private String account;

    private String password;




    public LoginUser() {
    }

    public LoginUser(String account, String password) {
        this.account = account;
        this.password = password;
    }

    public String getUsername() {
        return account;
    }

    public void setUsername(String username) {
        this.account = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

}
