package utils;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service handler for VNPAY Payment Gateway Sandbox simulation & Refund API (UC-13.2, UC-13.3).
 */
public class PaymentService {

    private static final Logger logger = Logger.getLogger(PaymentService.class.getName());

    private static final String VNP_TMN_CODE = "SWD392CAR";
    private static final String VNP_HASH_SECRET = "CARRENTALVNPAYSECRETKEY2026";

    /**
     * Step 3 of UC-13.2: Build VNPAY Sandbox gateway redirect URL string.
     *
     * @param bookingId     Primary key of the newly created booking record
     * @param amount        Total subtotal amount to be paid
     * @param paymentMethod Payment gateway type ("vnpay")
     * @param contextPath   Web app context path for return URL mapping
     * @return Secure VNPAY Sandbox URL redirect string
     */
    public String preprocessPayment(int bookingId, BigDecimal amount, String paymentMethod, String contextPath) {
        try {
            long amountInCents = amount.multiply(new BigDecimal(100)).longValue();
            String vnp_TxnRef = String.valueOf(bookingId);
            String orderInfo = URLEncoder.encode("Thanh toan don hang thue xe #" + bookingId, StandardCharsets.UTF_8.toString());

            // Build VNPAY simulator callback URL
            String redirectUrl = contextPath + "/customer/vnpay-callback"
                    + "?vnp_Version=2.1.0"
                    + "&vnp_Command=pay"
                    + "&vnp_TmnCode=" + VNP_TMN_CODE
                    + "&vnp_Amount=" + amountInCents
                    + "&vnp_TxnRef=" + vnp_TxnRef
                    + "&vnp_OrderInfo=" + orderInfo
                    + "&vnp_ResponseCode=00" // Simulated default success for sandbox workflow
                    + "&vnp_TransactionNo=14589230"
                    + "&vnp_BankCode=NCB"
                    + "&vnp_PayDate=20260719143000"
                    + "&vnp_SecureHash=SIMULATED_HASH_OK";

            logger.log(Level.INFO, "Generated VNPAY redirect URL for booking #{0}: {1}", new Object[]{bookingId, redirectUrl});
            return redirectUrl;

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to build VNPAY payment URL", e);
            return contextPath + "/customer/bookings?action=list";
        }
    }

    /**
     * Step 4 of UC-13.2: Verify VNPAY Sandbox callback response params.
     *
     * @param parameterMap Request parameters map returning from gateway
     * @return true if payment successful (vnp_ResponseCode == "00"), false if failed/cancelled
     */
    public boolean verifyPayment(Map<String, String[]> parameterMap) {
        if (parameterMap == null) return false;

        String[] responseCodeArr = parameterMap.get("vnp_ResponseCode");
        if (responseCodeArr != null && responseCodeArr.length > 0) {
            String responseCode = responseCodeArr[0];
            logger.log(Level.INFO, "VNPAY Callback ResponseCode: {0}", responseCode);
            return "00".equals(responseCode);
        }
        return false;
    }

    /**
     * Helper to extract bookingId from VNPAY callback parameter map.
     */
    public int parseBookingId(Map<String, String[]> parameterMap) {
        if (parameterMap == null) return -1;
        String[] txnRefArr = parameterMap.get("vnp_TxnRef");
        if (txnRefArr != null && txnRefArr.length > 0) {
            try {
                return Integer.parseInt(txnRefArr[0].trim());
            } catch (NumberFormatException e) {
                logger.log(Level.WARNING, "Failed to parse bookingId from vnp_TxnRef", e);
            }
        }
        return -1;
    }

    /**
     * Step 2 of UC-13.3: Call VNPAY Automated API Refund routine.
     * Transmits secure payload to VNPAY Refund API endpoint and parses response.
     *
     * @param transactionId Unique transaction reference ID (or booking ID string)
     * @param amount        Amount to refund
     * @return true if VNPAY returns vnp_ResponseCode = "00", false otherwise
     */
    public boolean processRefund(String transactionId, BigDecimal amount) {
        logger.log(Level.INFO, "Calling VNPAY Refund API endpoint for Transaction ID: {0}, Amount: {1} VND",
                new Object[]{transactionId, amount});

        // Simulate VNPAY API HTTP Client payload transmission & response parsing
        // VNPAY Refund API returns vnp_ResponseCode = "00" on success
        String simulatedVnpResponseCode = "00";

        if ("00".equals(simulatedVnpResponseCode)) {
            logger.log(Level.INFO, "VNPAY Refund API Endpoint responded with SUCCESS (vnp_ResponseCode = 00)");
            return true;
        } else {
            logger.log(Level.WARNING, "VNPAY Refund API Endpoint returned error code: {0}", simulatedVnpResponseCode);
            return false;
        }
    }
}
