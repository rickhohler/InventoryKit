import Foundation

/// Represents lifecycle metadata for an asset.
/// Represents lifecycle metadata for an asset.
public protocol InventoryLifecycle: Sendable {
    var stage: InventoryLifecycleStage { get }
    var events: [any InventoryLifecycleEventProtocol] { get }
}

/// Individual lifecycle/provenance entries.
public protocol InventoryLifecycleEventProtocol: Sendable {
    var timestamp: Date? { get }
    var actor: String? { get }
    var note: String? { get }
}

/// Common asset lifecycle stages.
public enum InventoryLifecycleStage: String, Codable, Sendable {
    case acquired
    case active
    case maintenance
    case retired
    case disposed
}
