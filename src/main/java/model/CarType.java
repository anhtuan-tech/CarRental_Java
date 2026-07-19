package model;

/**
 * Maps to the [CarType] table in the CarRental database.
 */
public class CarType {

    private int typeId;
    private String typeName;
    private String description;

    public CarType() {}

    public CarType(int typeId, String typeName, String description) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.description = description;
    }

    // --- Getters & Setters ---

    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
