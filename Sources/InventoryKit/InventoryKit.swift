import Foundation
import InventoryTypes
import InventoryCore
import DesignAlgorithmsKit

/// The main entry point for the InventoryKit library.
/// Initializes the environment and services.
public final class InventoryKit: Sendable {
    /// The shared context containing dependencies.
    public let context: any Context
    
    /// The storage provider implementation.
    public let storage: any StorageProvider
    
    /// Configurator for forcing population of concrete types.
    public let configurator: any Configurator
    
    /// Public API Facade for accessing Inventory services.
    public let services: any InventoryServices
    
    // MARK: - Initialization
    
    /// Initializes InventoryKit with client-provided dependencies.
    /// - Parameters:
    ///   - storage: The storage provider implementation (must include all entity factories).
    ///   - configurator: The configurator implementation for populating concrete types.
    public init(storage: any StorageProvider, configurator: any Configurator) {
        self.storage = storage
        self.configurator = configurator
        let ctx = DefaultInventoryContext(storage: storage, configurator: configurator)
        self.context = ctx
        self.services = InventoryServiceFacade(storage: storage, configurator: configurator, context: ctx)
        
        // Configure the global system singleton
        System.shared.configure(with: storage)
    }
}

// MARK: - Default Context

/// Internal implementation of the InventoryContext.
private struct DefaultInventoryContext: Context {
    let storage: any StorageProvider
    let configurator: any Configurator
}
