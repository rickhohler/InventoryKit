import Foundation
import InventoryTypes

extension StorageQuery {
    
    // MARK: - Manufacturer Queries
    
    /// Query for a manufacturer by exact name (case insensitive usually depends on DB, but assume exact for now or standardize).
    public static func manufacturer(name: String) -> StorageQuery {
        return StorageQuery(filter: .field(key: "name", op: .equals, value: name), limit: 1)
    }
    
    /// Query for a manufacturer by exact slug.
    public static func manufacturer(slug: String) -> StorageQuery {
        return StorageQuery(filter: .field(key: "slug", op: .equals, value: slug), limit: 1)
    }
    
    // MARK: - Product Queries
    
    public static func product(title: String) -> StorageQuery {
        return StorageQuery(filter: .field(key: "title", op: .equals, value: title))
    }
    
    // MARK: - Asset Queries
    
    public static func asset(name: String) -> StorageQuery {
        return StorageQuery(filter: .field(key: "name", op: .equals, value: name))
    }
    
    public static func all() -> StorageQuery {
        return StorageQuery(filter: .all)
    }
}
