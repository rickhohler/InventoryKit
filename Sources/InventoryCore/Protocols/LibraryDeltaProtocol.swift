import Foundation

/// Protocol representing a specific library bundle version.
/// Library bundles are snapshots of the library at a point in time.
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public protocol LibraryBundleProtocol: Sendable {
    var bundleId: String { get }
    var bundleVersion: Int64 { get }
    var createdAt: Date { get }
    var dataSnapshotDate: Date { get }
    var products: [any InventoryProductProtocol] { get }
}

/// Protocol representing delta updates to the library since a bundle snapshot.
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public protocol LibraryDeltaProtocol: Sendable {
    /// Unique delta identifier
    var deltaId: String { get }
    
    /// Associated bundle ID
    var bundleId: String { get }
    
    /// Bundle version this delta applies to
    var bundleVersion: Int64 { get }
    
    /// Delta creation timestamp
    var createdAt: Date { get }
    
    /// Start date for delta (bundle snapshot date)
    var fromDate: Date { get }
    
    /// End date for delta
    var toDate: Date { get }
    
    /// Products created since bundle
    var createdProducts: [any InventoryProductProtocol] { get }
    
    /// Products updated since bundle
    var updatedProducts: [any InventoryProductProtocol] { get }
    
    /// Product IDs deleted since bundle
    var deletedProductIds: [UUID] { get }
}
