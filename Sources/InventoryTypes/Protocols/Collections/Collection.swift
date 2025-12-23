import Foundation

/// Defines the type of an Inventory Collection.
public enum CollectionType: String, Codable, Sendable {
    /// Provided by a Data Source (Public).
    case `public`
    /// Created by the User (Private).
    case personal
}

/// Defines the visibility of an Inventory Collection.
public enum CollectionVisibility: String, Codable, Sendable {
    /// Visible to everyone (Shared).
    case shared
    /// Visible only to the owner (Private).
    case `private`
}

// MARK: - Core Protocols

/// Basic information about a collection.
public protocol CollectionInfoProtocol {
    var title: String { get }
    var description: String? { get }
}

/// Source information for a collection.
public protocol CollectionSourceProtocol {
    /// The ID of the data source providing this collection (if applicable).
    var dataSourceID: UUID? { get }
}

/// Protocol defining a curated grouping of assets or products.
public protocol Collection: Sendable,
                                           CollectionInfoProtocol,
                                           CollectionSourceProtocol {
    var id: UUID { get }
    
    // Conforms to CollectionInfoProtocol
    // var title: String { get }
    // var description: String? { get }
    
    // Conforms to CollectionSourceProtocol
    // var dataSourceID: UUID? { get }
    
    /// The type of collection (Public vs. Personal).
    var type: CollectionType { get }
    
    /// The visibility realm (Shared vs. Private).
    var visibility: CollectionVisibility { get }
    
    /// The intent/mechanism of the grouping.
    var category: CollectionCategoryType { get }
    
    /// The list of item IDs in this collection.
    /// Uses IRNs (InventoryResourceName) for universal linking.
    var items: [InventoryResourceName] { get }
    
    var metadata: [String: String] { get }
}
