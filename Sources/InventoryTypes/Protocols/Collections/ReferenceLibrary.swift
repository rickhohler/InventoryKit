import Foundation

/// A "Reference Library" (Provider).
/// Represents the entity that provides the catalog data (e.g., Archive.org).
public protocol ReferenceLibrary: DataSource {
    /// Is this a trusted source?
    var isVerified: Bool { get }
}
