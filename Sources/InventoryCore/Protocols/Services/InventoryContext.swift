import Foundation

/// A Context object that provides access to the environment dependencies.
/// Passed to Services to allow them to access Storage, Logging, etc.
public protocol InventoryContext: Sendable {
    /// The Storage Provider Factory.
    var storage: any StorageProvider { get }
    
    /// Factory for creating concrete Asset instances.
    var assetFactory: any InventoryAssetFactory { get }
    
    /// Configurator for forcing population of concrete types (Dependency Injection).
    var configurator: any InventoryConfigurator { get }
}
