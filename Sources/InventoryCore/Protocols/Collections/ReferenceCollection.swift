import Foundation

/// A "Reference Collection" (Grouping).
/// A curated set or grouping of Products or Assets provided by a Library.
public protocol ReferenceCollection: InventoryCollection {
    /// The canonical URL for this collection (e.g. Archive.org details page).
    var infoUrl: URL? { get }
}
