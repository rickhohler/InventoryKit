import Foundation
import InventoryCore

// MARK: - Mock User Data Store
public actor MockUserDataStore: UserDataStore {
    private var files: [UUID: Data] = [:]
    
    public init() {}
    
    public func fileExists(for assetID: UUID) async -> Bool {
        files[assetID] != nil
    }
    
    public func fileURL(for assetID: UUID) async throws -> URL {
        // Return a dummy URL, but if asserting file existence via API, fileExists is key.
        URL(fileURLWithPath: "/tmp/\(assetID.uuidString)")
    }
    
    public func write(data: Data, for assetID: UUID) async throws {
        files[assetID] = data
    }
    
    public func write(from url: URL, for assetID: UUID) async throws {
        let data = try Data(contentsOf: url)
        files[assetID] = data
    }
    
    public func delete(assetID: UUID) async throws {
        files.removeValue(forKey: assetID)
    }
    
    public func size(of assetID: UUID) async throws -> Int64 {
        Int64(files[assetID]?.count ?? 0)
    }
    
    public func checksum(of assetID: UUID) async throws -> String {
        "dummy-checksum"
    }
}

// MARK: - Mock Domain Data Store
public actor MockDomainDataStore: DomainDataStore {
    public init() {}
    
    public func isCached(for resourceID: String) async -> Bool { false }
    public func fileURL(for resourceID: String) async throws -> URL { URL(fileURLWithPath: "/dev/null") }
    public func cache(resourceID: String, from remoteURL: URL) async throws {}
    public func purge(resourceID: String) async throws {}
    public func size(of resourceID: String) async throws -> Int64? { nil }
}

// MARK: - Mock User Metadata Store
public actor MockUserMetadataStore: UserMetadataStore {
    private var assets: [UUID: any InventoryAsset] = [:]
    
    public init() {}
    
    public func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset] {
        Array(assets.values)
    }
    
    public func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)? {
        assets[id]
    }
    
    public func saveAsset(_ asset: any InventoryAsset) async throws {
        assets[asset.id] = asset
    }
    
    public func deleteAsset(id: UUID) async throws {
        assets.removeValue(forKey: id)
    }
    
    public func fetchPersonalCollections(matching query: StorageQuery) async throws -> [any InventoryCollection] { [] }
    public func saveCollection(_ collection: any InventoryCollection) async throws {}
    public func deleteCollection(id: UUID) async throws {}
    
    public func performBatch(operations: @escaping () async throws -> Void) async throws {
        try await operations()
    }
}

// MARK: - Mock Domain Metadata Store
public actor MockDomainMetadataStore: DomainMetadataStore {
    public init() {}
    
    public func fetchProducts(matching query: StorageQuery) async throws -> [any InventoryProduct] { [] }
    public func retrieveProduct(id: UUID) async throws -> (any InventoryProduct)? { nil }
    public func saveProduct(_ product: any InventoryProduct) async throws {}
    
    public func fetchPublicCollections(matching query: StorageQuery) async throws -> [any InventoryCollection] { [] }
    public func saveCollection(_ collection: any InventoryCollection) async throws {}
}

// MARK: - Mock Storage Provider
public struct MockStorageProvider: StorageProvider {
    public var userMetadata: any UserMetadataStore
    public var domainMetadata: any DomainMetadataStore
    public var userData: any UserDataStore
    public var domainData: any DomainDataStore
    
    public init(
        userMetadata: any UserMetadataStore = MockUserMetadataStore(),
        domainMetadata: any DomainMetadataStore = MockDomainMetadataStore(),
        userData: any UserDataStore = MockUserDataStore(),
        domainData: any DomainDataStore = MockDomainDataStore()
    ) {
        self.userMetadata = userMetadata
        self.domainMetadata = domainMetadata
        self.userData = userData
        self.domainData = domainData
    }
}
