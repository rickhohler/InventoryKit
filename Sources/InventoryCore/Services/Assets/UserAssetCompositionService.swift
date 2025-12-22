import Foundation
import DesignAlgorithmsKit

/// Service for composing new Private User Assets.
/// Uses the DAK `Builder` pattern to construct the asset and persists it via the Context.
public actor UserAssetCompositionService {
    private let context: any InventoryContext
    
    public init(context: any InventoryContext) {
        self.context = context
    }
    
    public struct CompositionRequest: Sendable {
        public let name: String
        public let sourceURL: URL
        public let provenance: String
        public let tags: [String]
        
        public init(name: String, sourceURL: URL, provenance: String, tags: [String] = []) {
            self.name = name
            self.sourceURL = sourceURL
            self.provenance = provenance
            self.tags = tags
        }
    }
    
    /// Composes a new User Asset from a file.
    /// 1. Creates Asset Metadata.
    /// 2. Ingests File into UserDataStore.
    /// 3. Saves Metadata to UserMetadataStore.
    public func compose(request: CompositionRequest) async throws -> UUID {
        // 1. Generate Identity
        let assetID = UUID()
        
        // 2. Ingest File (Private Vault)
        try await context.storage.userData.write(from: request.sourceURL, for: assetID)
        
        // 3. Create Metadata (Private Object)
        let asset = try context.assetFactory.createAsset(
            id: assetID,
            name: request.name,
            provenance: request.provenance,
            tags: request.tags
        )
        
        // 4. Save Metadata
        try await context.storage.userMetadata.saveAsset(asset)
        
        return assetID
    }
}


