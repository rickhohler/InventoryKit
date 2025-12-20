import Foundation

/// Protocol definition for a temporary, detached copy of an Asset used specifically for Metadata Editing.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol DraftAssetProtocol: Identifiable, Sendable {
    var id: UUID { get }
    
    /// The ID of the original asset being edited.
    var originalAssetID: UUID { get }
    
    /// The set of fields that have been modified.
    var dirtyFields: Set<String> { get set }
    
    /// The staged metadata values (Key-Value).
    var stagedMetadata: [String: String] { get set }
    
    /// The staged tags.
    var stagedTags: [String] { get set }
    
    /// Marks a field as dirty and updates metadata.
    mutating func updateMetadata(key: String, value: String)
    
    /// Updates tags and marks field as dirty.
    mutating func updateTags(_ tags: [String])
}
