package com.envision.demo.bean;

public class PublicKey {

    private String keyId;
    private String publicKey;

    public PublicKey() {
    }

    public PublicKey(String keyId, String publicKey) {
        this.keyId = keyId;
        this.publicKey = publicKey;
    }

    public String getKeyId() {
        return keyId;
    }

    public void setKeyId(String keyId) {
        this.keyId = keyId;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

}
