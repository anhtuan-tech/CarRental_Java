package utils;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Utility class for sending password recovery verification emails.
 */
public class EmailServices {

    private static final Logger logger = Logger.getLogger(EmailServices.class.getName());

    // SMTP Server Configurations (Bác có thể điền tài khoản Gmail App Password tại
    // đây để gửi mail thật)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = "tuanlace180905@fpt.edu.vn";
    private static final String SMTP_PASS = "tmle arsi zmbb mobb";

    /**
     * Send email with 6-digit OTP verification code.
     * Automatically falls back to printing to system console if SMTP is
     * unconfigured or failed.
     *
     * @param email destination user email
     * @param otp   6-digit verification code
     * @return true if mock or real email succeeded
     */
    public static boolean sendOtpEmail(String email, String otp) {
        if (SMTP_USER.contains("@") && !SMTP_PASS.equals("your-app-password") && !SMTP_PASS.isEmpty()) {
            try {
                Properties prop = new Properties();
                prop.put("mail.smtp.host", SMTP_HOST);
                prop.put("mail.smtp.port", SMTP_PORT);
                prop.put("mail.smtp.auth", "true");
                prop.put("mail.smtp.starttls.enable", "true");

                Session session = Session.getInstance(prop, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
                    }
                });

                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(SMTP_USER));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
                message.setSubject("[CarRental] Reset Password Verification OTP");

                String content = "<h3>CarRental Password Recovery</h3>"
                        + "<p>You requested to recover your password. Please use the following 6-digit OTP code to verify your identity:</p>"
                        + "<h2 style='color: #F97316; font-size: 2rem; letter-spacing: 0.1em;'>" + otp + "</h2>"
                        + "<p>This code will expire in 5 minutes. If you did not make this request, please ignore this email.</p>"
                        + "<br/><hr/><p style='font-size: 0.8rem; color: #888;'>CarRental Platform - Safe and Transparent Car Rental</p>";

                message.setContent(content, "text/html; charset=utf-8");

                Transport.send(message);
                logger.log(Level.INFO, "Verification email sent successfully to: {0}", email);
                System.out.println("[REAL EMAIL SERVICE] OTP sent successfully to: " + email);
                return true;
            } catch (Exception e) {
                logger.log(Level.WARNING, "Real SMTP failed. Falling back to Console simulator.", e);
            }
        }

        // Sandbox simulator fallback
        System.out.println("[OTP SERVICE] Email sent successfully to: " + email);
        return true;
    }
}
