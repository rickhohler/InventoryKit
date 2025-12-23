import Foundation

extension Bundle {
    /// Returns the main app bundle if it contains the "InventoryKit" identifier,
    /// otherwise falls back to the module bundle.
    /// This allows the hosting app to override localizations if needed.
    public static var inventoryKit: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        // Fallback for non-SPM contexts or manual integration
        let bundle = Bundle(for: SchemaVersion.self)
        return bundle
        #endif
    }
}
