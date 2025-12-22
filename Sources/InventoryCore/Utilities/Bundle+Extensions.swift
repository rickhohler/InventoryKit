import Foundation

extension Bundle {
    /// Returns the main app bundle if it contains the "InventoryKit" identifier,
    /// otherwise falls back to the module bundle.
    /// This allows the hosting app to override localizations if needed.
    static var inventoryKit: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        // Fallback for non-SPM contexts or manual integration
        let bundle = Bundle(for: ReferenceProductBuilder.self)
        return bundle
        #endif
    }
}
