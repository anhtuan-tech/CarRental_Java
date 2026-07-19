package model;

/**
 * Maps to the [Profile] table in the CarRental database.
 */
public class Profile {

    private int profileId;
    private int userId;
    private String fullName;
    private String avatarUrl;       // BR11: only JPG/PNG, max 5MB
    private String driverLicense;
    private String idCardNo;
    private String address;

    public Profile() {}

    public Profile(int profileId, int userId, String fullName, String avatarUrl,
                   String driverLicense, String idCardNo, String address) {
        this.profileId = profileId;
        this.userId = userId;
        this.fullName = fullName;
        this.avatarUrl = avatarUrl;
        this.driverLicense = driverLicense;
        this.idCardNo = idCardNo;
        this.address = address;
    }

    // --- Getters & Setters ---

    public int getProfileId() { return profileId; }
    public void setProfileId(int profileId) { this.profileId = profileId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getDriverLicense() { return driverLicense; }
    public void setDriverLicense(String driverLicense) { this.driverLicense = driverLicense; }

    public String getIdCardNo() { return idCardNo; }
    public void setIdCardNo(String idCardNo) { this.idCardNo = idCardNo; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
