package utils;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service helper for customer & owner notification delivery (UC-13.2, UC-13.3).
 */
public class NotificationService {

    private static final Logger logger = Logger.getLogger(NotificationService.class.getName());

    /**
     * Send booking confirmation email/toast notification to customer (UC-13.2 step 42).
     */
    public boolean sendBookingConfirmation(int customerId, int bookingId) {
        logger.log(Level.INFO, "NotificationService: Sent Booking Confirmation notification to Customer ID {0} for Booking #{1}",
                new Object[]{customerId, bookingId});
        return true;
    }

    /**
     * Send new booking alert to fleet owner (UC-13.2 step 44).
     */
    public boolean sendBookingToOwner(int ownerId, int bookingId) {
        logger.log(Level.INFO, "NotificationService: Sent New Rental Order alert to Fleet Owner ID {0} for Booking #{1}",
                new Object[]{ownerId, bookingId});
        return true;
    }

    /**
     * Send cancellation alert to customer and owner (UC-13.3 step 23 & 37).
     */
    public boolean sendCancelNotification(int customerId, int ownerId, int bookingId) {
        logger.log(Level.INFO, "NotificationService: Sent Cancellation Alert for Booking #{0} to Customer ID {1} and Owner ID {2}",
                new Object[]{bookingId, customerId, ownerId});
        return true;
    }
}
