import Foundation

/// Protocol definition for a mutable working copy of an Inventory Asset.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol WorkbenchItem: Identifiable, Sendable {
    var id: UUID { get }
    
    /// The original asset this item is derived from.
    var sourceAssetID: UUID { get }
    
    /// The Mutable wrapper containing the full compound object.
    var contents: (any InventoryCompoundBase) { get set }
    
    /// The location of the mutable working file (e.g., in a temporary directory).
    var workingFileURL: URL { get }
    
    /// The state of the item in the workbench.
    var state: WorkbenchState { get set }
    
    /// Whether the item has unsaved modifications.
    var isModified: Bool { get }
}

/// State of a Workbench Item.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum WorkbenchState: String, Codable, Sendable {
    case ready
    case modified
    case saving
    case error
}
