package com.envision.demo.util;

import android.util.Base64;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


/*******************************************************************************
 * AES加解密算法
 *
 * @author jueyue
 *         <p>
 *         <p>
 *         加密用的Key 可以用26个字母和数字组成，最好不要用保留字符，虽然不会错，至于怎么裁决，个人看情况而定
 *         此处使用AES-128-CBC加密模式，key需要为16位。
 *         也是使用 0102030405060708
 */

public class AESUtil {
    private static String ALGO = "AES"; //算法
    private static String ALGO_MODE_PATTERN = "AES/CBC/PKCS5Padding";//算法/模式/补码方式
    private static String DEF_KEY = "sfsafasdfsafasff"; //16位
    private static String DEF_IV = "phjlknslfdhksldf";

    public static void setDefKey(String key) {
        DEF_KEY = key;
    }

    public static void setDefIv(String iv) {
        DEF_IV = iv;
    }

    public static String encrypt(String sSrc) throws NoSuchPaddingException, InvalidAlgorithmParameterException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException {
        return encrypt(sSrc, DEF_KEY);
    }

    public static String encrypt(String sSrc, String sKey) throws NoSuchPaddingException, InvalidKeyException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
        return encrypt(sSrc, sKey, DEF_IV);
    }

    // 加密
    public static String encrypt(String sSrc, String sKey, String sIv) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidAlgorithmParameterException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
        if (sKey == null) {
//            System.out.print("Key为空null");
            return null;
        }
        if (sKey.length() != 16) {
//            System.out.print("Key长度不是16位");
            return null;
        }
        byte[] raw = sKey.getBytes();
        SecretKeySpec skeySpec = new SecretKeySpec(raw, ALGO);
        Cipher cipher = Cipher.getInstance(ALGO_MODE_PATTERN);
        IvParameterSpec iv = new IvParameterSpec(sIv.getBytes());//使用CBC模式，需要一个向量iv，可增加加密算法的强度
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv);
        byte[] encrypted = cipher.doFinal(sSrc.getBytes());
        return Base64.encodeToString(encrypted, Base64.DEFAULT);//此处使用BAES64做转码功能，同时能起到2次加密的作用。
    }

    public static String decrypt(String sSrc) throws NoSuchPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchAlgorithmException, InvalidKeyException {
        return decrypt(sSrc, DEF_KEY);
    }

    public static String decrypt(String sSrc, String sKey) throws NoSuchPaddingException, InvalidKeyException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, NoSuchAlgorithmException, InvalidAlgorithmParameterException {
        return decrypt(sSrc, sKey, DEF_IV);
    }

    // 解密
    public static String decrypt(String sSrc, String sKey, String sIv) throws UnsupportedEncodingException, NoSuchPaddingException, NoSuchAlgorithmException, InvalidAlgorithmParameterException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
        // 判断Key是否正确
        if (sKey == null) {
            return null;
        }
        // 判断Key是否为16位
        if (sKey.length() != 16) {
            return null;
        }
        byte[] raw = sKey.getBytes("ASCII");
        SecretKeySpec skeySpec = new SecretKeySpec(raw, ALGO);
        Cipher cipher = Cipher.getInstance(ALGO_MODE_PATTERN);
        IvParameterSpec iv = new IvParameterSpec(sIv.getBytes());
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
        byte[] encrypted1 = Base64.decode(sSrc, Base64.DEFAULT);//先用bAES64解密
        byte[] original = cipher.doFinal(encrypted1);
        return new String(original);
    }
}

