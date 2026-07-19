package model;

/**
 * Maps to the [CarImage] table in the CarRental database.
 */
public class CarImage {

    private int imageId;
    private int carId;
    private String imageUrl;
    private boolean isPrimary;

    public CarImage() {}

    public CarImage(int imageId, int carId, String imageUrl, boolean isPrimary) {
        this.imageId = imageId;
        this.carId = carId;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
    }

    // --- Getters & Setters ---

    public int getImageId() { return imageId; }
    public void setImageId(int imageId) { this.imageId = imageId; }

    public int getCarId() { return carId; }
    public void setCarId(int carId) { this.carId = carId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public boolean isPrimary() { return isPrimary; }
    public void setPrimary(boolean primary) { isPrimary = primary; }
}
