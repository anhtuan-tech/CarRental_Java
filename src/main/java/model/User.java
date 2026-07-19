package model;

import java.time.LocalDateTime;

/**
 * Maps to the [User] table in the CarRental database.
 * Role IDs: 1=Customer, 2=Staff, 3=Owner, 4=Admin
 */
public class User {

    private int userId;
    private int roleId;
    private String email;
    private String password;        // stored as SHA-256 hex – NEVER displayed on UI (BR3)
    private String phoneNumber;
    private String status;          // Active | Inactive | Blocked
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // BR51 – Brute-force protection columns (migration required if not present)
    private int failedAttempts;
    private LocalDateTime lockUntil;

    // Transient helper fields
    private String fullName;

    public User() {}

    public User(int userId, int roleId, String email, String password,
                String phoneNumber, String status,
                LocalDateTime createdAt, LocalDateTime updatedAt,
                int failedAttempts, LocalDateTime lockUntil) {
        this.userId = userId;
        this.roleId = roleId;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.failedAttempts = failedAttempts;
        this.lockUntil = lockUntil;
    }

    // --- Getters & Setters ---

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public int getFailedAttempts() { return failedAttempts; }
    public void setFailedAttempts(int failedAttempts) { this.failedAttempts = failedAttempts; }

    public LocalDateTime getLockUntil() { return lockUntil; }
    public void setLockUntil(LocalDateTime lockUntil) { this.lockUntil = lockUntil; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
}
