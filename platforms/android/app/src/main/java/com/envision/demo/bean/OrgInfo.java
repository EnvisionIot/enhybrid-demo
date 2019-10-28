package com.envision.demo.bean;

import java.util.List;

public class OrgInfo {
    public OrgInfo(Pagination pagination, List<Org2> organizations) {
        this.pagination = pagination;
        this.organizations = organizations;
    }

    public OrgInfo() {
    }

    public Pagination getPagination() {
        return pagination;
    }

    public void setPagination(Pagination pagination) {
        this.pagination = pagination;
    }

    public List<Org2> getOrganizations() {
        return organizations;
    }

    public void setOrganizations(List<Org2> organizations) {
        this.organizations = organizations;
    }

    public static class Org2 {
        String id;
        String name;
        String description;
        String code;

        public Org2(String id, String name, String description, String code) {
            this.id = id;
            this.name = name;
            this.description = description;
            this.code = code;
        }

        public Org2() {
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

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }
    }
    Pagination pagination;
    List<Org2> organizations;

}

