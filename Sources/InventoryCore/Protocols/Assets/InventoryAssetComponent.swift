import Foundation

/// A concrete instance of an **InventoryItem** inside an Asset.
/// Represents a file or component in the user's possession.
public protocol InventoryAssetComponent: InventoryItem {
    /// Forensic State (e.g. "Original Dump", "Cracked", "Modified").
    var forensicState: String? { get }
    
    /// Physical State (e.g. "Capacitor Leaking", "Tested OK").
    var physicalState: String? { get }
}
