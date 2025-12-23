import Foundation

/// Helper for retrieving localized strings with a client-app priority.
/// Checks the main bundle first, falling back to InventoryKit's bundle.
///
/// - Parameters:
///   - key: The key for the localized string.
///   - value: The default value if not found in either bundle.
///   - comment: Contextual note for the translator.
/// - Returns: The localized string.
public func InventoryLocalizedString(_ key: String, value: String, comment: String) -> String {
    // 1. Try Main Bundle (Client App)
    // We use a specific missing marker to detect if the client has the string.
    let missingMarker = "~~IK_MISSING~~"
    let clientValue = NSLocalizedString(key, bundle: .main, value: missingMarker, comment: comment)
    
    if clientValue != missingMarker {
        return clientValue
    }
    
    // 2. Fallback to InventoryKit Bundle
    // Note: Bundle.inventoryKit is defined in Bundle+Extensions.swift in InventoryCore
    return NSLocalizedString(key, bundle: .inventoryKit, value: value, comment: comment)
}
