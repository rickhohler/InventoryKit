import Foundation

/// Represents lifecycle metadata for an asset.
public struct InventoryLifecycle: Codable, Equatable, Hashable, Sendable {
    public var stage: InventoryLifecycleStage
    public var events: [InventoryLifecycleEvent]

    public init(stage: InventoryLifecycleStage, events: [InventoryLifecycleEvent] = []) {
        self.stage = stage
        self.events = events
    }
}

/// Individual lifecycle/provenance entries.
public struct InventoryLifecycleEvent: Codable, Equatable, Hashable, Sendable {
    public var timestamp: Date?
    public var actor: String?
    public var note: String?

    public init(timestamp: Date? = nil, actor: String? = nil, note: String? = nil) {
        self.timestamp = timestamp
        self.actor = actor
        self.note = note
    }
}

/// Common asset lifecycle stages.
public enum InventoryLifecycleStage: String, Codable, Sendable {
    case acquired
    case active
    case maintenance
    case retired
    case disposed
}
