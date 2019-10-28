package com.envision.demo.bean;

public class App {
    private String id;
    private String name;
    private String url;
    private Category category;

    public App() {
    }

    public App(String id, String name, String url, Category category) {
        this.id = id;
        this.name = name;
        this.url = url;
        this.category = category;
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
