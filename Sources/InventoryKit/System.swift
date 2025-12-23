import Foundation
import InventoryTypes
import DesignAlgorithmsKit
import InventoryCore

/// A central system singleton that holds global configuration.
/// Used to provide services with access to the client-provided storage factories.
public final class System: ThreadSafeSingleton, @unchecked Sendable {
    
    /// The storage configurator containing repositories.
    public private(set) var storageConfigurator: (any StorageConfigurator)?
    
    /// Required by ThreadSafeSingleton.
    public override class func createShared() -> System {
        return System()
    }
    
    /// Configures the system with the client's storage mechanism.
    /// - Parameter configurator: The storage configurator containing repositories.
    public func configure(with configurator: any StorageConfigurator) {
        self.storageConfigurator = configurator
    }
}
