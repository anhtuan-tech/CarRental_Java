package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Password utility class providing SHA-256 hashing.
 * BR13/BR14: Passwords must never be stored in plain text.
 */
public class PasswordUtils {

    private PasswordUtils() {
        // Utility class – no instantiation
    }

    /**
     * Hash a plain-text password using SHA-256 and return the hex string.
     *
     * @param plainText the raw password
     * @return 64-character hex string, or null on algorithm error
     */
    public static String hashSHA256(String plainText) {
        if (plainText == null || plainText.isEmpty()) {
            return null;
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(plainText.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(PasswordUtils.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Verify a plain-text password against a stored SHA-256 hash.
     *
     * @param plainText    the raw password to check
     * @param storedHash   the stored SHA-256 hex hash
     * @return true if match, false otherwise
     */
    public static boolean verify(String plainText, String storedHash) {
        String hashed = hashSHA256(plainText);
        return hashed != null && hashed.equals(storedHash);
    }
}
