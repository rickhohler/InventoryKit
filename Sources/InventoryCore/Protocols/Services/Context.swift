import Foundation
import InventoryTypes

/// A Context object that provides access to the environment dependencies.
/// Passed to Services to allow them to access Storage, Logging, etc.
public protocol Context: Sendable {
    /// The Storage Provider Factory (which contains all Entity Factories).
    var storage: any StorageProvider { get }
    
    /// Configurator for forcing population of concrete types (Dependency Injection).
    var configurator: any Configurator { get }
}
