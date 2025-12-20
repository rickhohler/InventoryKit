import Foundation

/// Helper for constructing IRNs fluently.
public struct InventoryResourceNameBuilder {
    
    /// Create a Public Product IRN.
    /// `inventory:public:product:global:{type}:{id}`
    public static func publicProduct(type: String, id: UUID) -> InventoryResourceName {
        return InventoryResourceName(
            partition: .public,
            service: .product,
            namespace: "global",
            type: type,
            id: id.uuidString.lowercased()
        )
    }
    
    /// Create a Private Asset IRN.
    /// `inventory:private:asset:{userID}:{type}:{id}`
    public static func privateAsset(userID: UUID, type: String, id: UUID) -> InventoryResourceName {
        return InventoryResourceName(
            partition: .private,
            service: .asset,
            namespace: userID.uuidString.lowercased(),
            type: type,
            id: id.uuidString.lowercased()
        )
    }
    
    /// Create a Public Collection IRN (from Vendor).
    /// `inventory:public:collection:{vendorID}:collection:{id}`
    public static func publicCollection(vendorID: UUID, id: UUID) -> InventoryResourceName {
        return InventoryResourceName(
            partition: .public,
            service: .collection,
            namespace: vendorID.uuidString.lowercased(),
            type: "collection", // Explicit type
            id: id.uuidString.lowercased()
        )
    }
}
