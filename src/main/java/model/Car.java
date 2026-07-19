package model;

import java.math.BigDecimal;

/**
 * Maps to the [Car] table in the CarRental database.
 */
public class Car {

    private int carId;
    private int ownerId;
    private int typeId;
    private String carName;
    private String brand;
    private String model;
    private String licensePlate;
    private String specsJson;
    private BigDecimal pricePerDay;  // BR3: displayed formatted in VND
    private String status;
    private String documentUrl;

    // Transient helpers – not persisted; populated by DAO joins
    private String primaryImageUrl;
    private String typeName;
    private String ownerName;

    public Car() {}

    public Car(int carId, int ownerId, int typeId, String carName, String brand,
               String model, String licensePlate, String specsJson,
               BigDecimal pricePerDay, String status, String documentUrl) {
        this.carId = carId;
        this.ownerId = ownerId;
        this.typeId = typeId;
        this.carName = carName;
        this.brand = brand;
        this.model = model;
        this.licensePlate = licensePlate;
        this.specsJson = specsJson;
        this.pricePerDay = pricePerDay;
        this.status = status;
        this.documentUrl = documentUrl;
    }

    // --- Getters & Setters ---

    public int getCarId() { return carId; }
    public void setCarId(int carId) { this.carId = carId; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }

    public String getCarName() { return carName; }
    public void setCarName(String carName) { this.carName = carName; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public String getSpecsJson() { return specsJson; }
    public void setSpecsJson(String specsJson) { this.specsJson = specsJson; }

    public BigDecimal getPricePerDay() { return pricePerDay; }
    public void setPricePerDay(BigDecimal pricePerDay) { this.pricePerDay = pricePerDay; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDocumentUrl() { return documentUrl; }
    public void setDocumentUrl(String documentUrl) { this.documentUrl = documentUrl; }

    public String getPrimaryImageUrl() { return primaryImageUrl; }
    public void setPrimaryImageUrl(String primaryImageUrl) { this.primaryImageUrl = primaryImageUrl; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }
}
