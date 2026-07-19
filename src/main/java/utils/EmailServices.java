package utils;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Mock email services utility class for forgot password mechanism.
 */
public class EmailServices {

    private static final Logger logger = Logger.getLogger(EmailServices.class.getName());

    /**
     * Mock sending reset password email.
     *
     * @param email destination email
     * @return true if mock email succeeded
     */
    public static boolean sendResetPasswordEmail(String email) {
        logger.log(Level.INFO, "Mock email sent successfully to: {0}", email);
        System.out.println("[MOCK EMAIL SERVICE] Password reset instruction sent to: " + email);
        return true;
    }
}
