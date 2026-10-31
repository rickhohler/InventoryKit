import Foundation
import InventoryTypes
import DesignAlgorithmsKit
import InventoryCore

/// A process-wide singleton that records the storage configurator of the last `InventoryKit`
/// created. Nothing in the library reads it, and with several `InventoryKit` instances the last
/// one wins, so it is deprecated: pass `StorageProvider` and `Context` to services instead.
/// `InventoryKit.init` still records its storage here in 2.x; 3.0 removes `System`.
public final class System: ThreadSafeSingleton, @unchecked Sendable {

    private let lock = NSLock()
    private var configurator: (any StorageConfigurator)?

    /// The storage configurator of the last `InventoryKit` created.
    @available(*, deprecated, message: "Nothing reads this global; pass StorageProvider and Context to services instead. Removed in 3.0.")
    public var storageConfigurator: (any StorageConfigurator)? {
        lock.withLock { configurator }
    }
    
    /// Required by ThreadSafeSingleton.
    public override class func createShared() -> System {
        return System()
    }
    
    /// Configures the system with the client's storage mechanism.
    /// - Parameter configurator: The storage configurator containing repositories.
    @available(*, deprecated, message: "Nothing reads this global; pass StorageProvider and Context to services instead. Removed in 3.0.")
    public func configure(with configurator: any StorageConfigurator) {
        record(configurator)
    }

    /// Records `configurator` (used by `InventoryKit.init` until 3.0).
    func record(_ configurator: any StorageConfigurator) {
        lock.withLock { self.configurator = configurator }
    }
}
