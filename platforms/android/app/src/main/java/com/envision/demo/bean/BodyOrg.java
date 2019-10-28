package com.envision.demo.bean;

public class BodyOrg {
    private String organizationId;

    public BodyOrg(String organizationId) {
        this.organizationId = organizationId;
    }

    public BodyOrg() {
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }
}
