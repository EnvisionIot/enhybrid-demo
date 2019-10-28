package com.envision.demo.bean;

public class UserInfo {
    String id;
    String name;
    String nickName;
    String phoneArea;
    String phone;
    String email;
    String description;
    String createdTime;

    public UserInfo() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public String getPhoneArea() {
        return phoneArea;
    }

    public void setPhoneArea(String phoneArea) {
        this.phoneArea = phoneArea;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(String createdTime) {
        this.createdTime = createdTime;
    }

    public UserInfo(String id, String name, String nickName, String phoneArea, String phone, String email, String description, String createdTime) {
        this.id = id;
        this.name = name;
        this.nickName = nickName;
        this.phoneArea = phoneArea;
        this.phone = phone;
        this.email = email;
        this.description = description;
        this.createdTime = createdTime;
    }

}
