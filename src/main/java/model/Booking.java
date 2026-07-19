package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Maps to the [Booking] table.
 */
public class Booking {

    private int bookingId;
    private int customerId;
    private int carId;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private int totalDays;
    private BigDecimal subtotalFee;
    private BigDecimal platformCommission;
    private BigDecimal ownerPayout;
    private String status;
    private LocalDateTime createdAt;

    // Transient fields for UI and join views
    private String customerName;
    private String carName;
    private String brand;
    private String licensePlate;
    private String carImageUrl;
    private BigDecimal pricePerDay;
    private int ownerId;
    private String ownerName;

    public Booking() {}

    // --- Getters & Setters ---

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getCarId() { return carId; }
    public void setCarId(int carId) { this.carId = carId; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }

    public BigDecimal getSubtotalFee() { return subtotalFee; }
    public void setSubtotalFee(BigDecimal subtotalFee) { this.subtotalFee = subtotalFee; }

    public BigDecimal getPlatformCommission() { return platformCommission; }
    public void setPlatformCommission(BigDecimal platformCommission) { this.platformCommission = platformCommission; }

    public BigDecimal getOwnerPayout() { return ownerPayout; }
    public void setOwnerPayout(BigDecimal ownerPayout) { this.ownerPayout = ownerPayout; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCarName() { return carName; }
    public void setCarName(String carName) { this.carName = carName; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public String getCarImageUrl() { return carImageUrl; }
    public void setCarImageUrl(String carImageUrl) { this.carImageUrl = carImageUrl; }

    public BigDecimal getPricePerDay() { return pricePerDay; }
    public void setPricePerDay(BigDecimal pricePerDay) { this.pricePerDay = pricePerDay; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    private boolean reviewed;
    public boolean isReviewed() { return reviewed; }
    public void setReviewed(boolean reviewed) { this.reviewed = reviewed; }
}
