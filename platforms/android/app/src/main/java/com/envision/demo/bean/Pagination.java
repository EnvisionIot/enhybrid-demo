package com.envision.demo.bean;

public class Pagination {
    Integer total;
    Integer currentPage;
    Integer limit;

    public Pagination(Integer total, Integer currentPage, Integer limit) {
        this.total = total;
        this.currentPage = currentPage;
        this.limit = limit;
    }

    public Pagination() {
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public Integer getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(Integer currentPage) {
        this.currentPage = currentPage;
    }

    public Integer getLimit() {
        return limit;
    }

    public void setLimit(Integer limit) {
        this.limit = limit;
    }
}
