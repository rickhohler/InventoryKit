import Foundation
import InventoryCore

public struct MockDraftAsset: DraftAsset {
    public let id: UUID
    public let originalAssetID: UUID
    public var dirtyFields: Set<String>
    public var stagedMetadata: [String: String]
    public var stagedTags: [String]
    
    public init(id: UUID = UUID(), originalAssetID: UUID) {
        self.id = id
        self.originalAssetID = originalAssetID
        self.dirtyFields = []
        self.stagedMetadata = [:]
        self.stagedTags = []
    }
    
    public mutating func updateMetadata(key: String, value: String) {
        stagedMetadata[key] = value
        dirtyFields.insert("metadata.\(key)")
    }
    
    public mutating func updateTags(_ tags: [String]) {
        self.stagedTags = tags
        dirtyFields.insert("tags")
    }
}
