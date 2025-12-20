import Foundation

/// A Context object that provides access to the environment dependencies.
/// Passed to Services to allow them to access Storage, Logging, etc.
public protocol InventoryContext: Sendable {
    /// The Storage Provider Factory.
    var storage: any StorageProviderProtocol { get }
    
    /// Factory for creating concrete Asset instances.
    var assetFactory: any InventoryAssetFactory { get }
}
