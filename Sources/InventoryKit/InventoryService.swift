import Foundation
import InventoryCore

/// High-level SDK entry point that wires storage providers, libraries, and logging together.
///
/// `InventoryService` provides a unified interface for managing both user inventory assets
/// and public library (products/vendors) operations.
///
/// Use the static `bootstrap(configuration:)` method to create a configured service instance.
///
/// ## Usage
///
/// ```swift
/// // Configure providers
/// let config = InventoryConfiguration(
///     provider: ioStorageProvider,
///     libraryProvider: cloudStorageProvider
/// )
/// let service = try await InventoryService.bootstrap(configuration: config)
///
/// // User Assets
/// await service.catalog.upsert(asset)
///
/// // Public Library
/// if let product = try await service.librarySync?.fetchProduct(id: productID) {
///     print("Found product: \(product.title)")
/// }
/// ```
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public actor InventoryService {
    public let configuration: InventoryConfiguration
    public let catalog: InventoryCatalog
    
    /// Optional service for library synchronization and public product access.
    /// Available only if `libraryProvider` was configured.
    public let librarySync: LibrarySyncService?
    
    /// Tag registry for tag-based code execution.
    public let tagRegistry: any InventoryTagRegistry

    private let logger: InventoryLogger

    private init(
        configuration: InventoryConfiguration,
        catalog: InventoryCatalog,
        librarySync: LibrarySyncService?,
        logger: InventoryLogger,
        tagRegistry: any InventoryTagRegistry
    ) {
        self.configuration = configuration
        self.catalog = catalog
        self.librarySync = librarySync
        self.logger = logger
        self.tagRegistry = tagRegistry
    }

    /// Bootstraps a new `InventoryService` instance with the provided configuration.
    public static func bootstrap(configuration: InventoryConfiguration) async throws -> InventoryService {
        let logger = InventoryLogger(level: configuration.logLevel)
        logger.info("Bootstrapping inventory via provider \(configuration.provider.identifier)")
        
        // 1. Load User Inventory
        let doc = try await configuration.provider.loadInventory(validatingAgainst: configuration.schemaVersion)
        logger.debug("Loaded \(doc.assets.count) assets")
        let concreteDoc = doc as? InventoryDocument ?? InventoryDocument(
             schemaVersion: doc.schemaVersion,
             info: doc.info,
             protocolAssets: doc.assets
        )
        let catalog = InventoryCatalog(document: concreteDoc)
        
        // 2. Initialize Library Sync (if provider configured)
        var librarySync: LibrarySyncService? = nil
        if let libraryProvider = configuration.libraryProvider {
            logger.info("Initializing public library via provider \(libraryProvider.identifier)")
            librarySync = LibrarySyncService(storageProvider: libraryProvider)
        }
        
        // 3. Initialize Tag Registry
        let tagRegistry: any InventoryTagRegistry = configuration.tagRegistry ?? DefaultTagRegistry()
        
        return InventoryService(
            configuration: configuration,
            catalog: catalog,
            librarySync: librarySync,
            logger: logger,
            tagRegistry: tagRegistry
        )
    }

    public func refreshFromProvider() async throws {
        logger.info("Refreshing inventory from provider \(configuration.provider.identifier)")
        let doc = try await configuration.provider.loadInventory(validatingAgainst: configuration.schemaVersion)
        let concreteDoc = doc as? InventoryDocument ?? InventoryDocument(
             schemaVersion: doc.schemaVersion,
             info: doc.info,
             protocolAssets: doc.assets
        )
        await catalog.replaceDocument(concreteDoc)
        logger.debug("Catalog replaced with \(concreteDoc.assets.count) assets")
    }

    public func persistChanges() async throws {
        logger.info("Persisting inventory via provider \(configuration.provider.identifier)")
        let document = await catalog.snapshotDocument()
        try await configuration.provider.saveInventory(document)
        logger.debug("Persisted \(document.assets.count) assets")
    }

    // MARK: Convenience APIs

    /// Lists assets with pagination, returning protocol `InventoryAssetProtocol` types.
    public func listAssets(page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<any InventoryAssetProtocol> {
        await catalog.paginatedAssets(page: page)
    }

    public func listAssets(taggedWith tags: Set<String>, page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<any InventoryAssetProtocol> {
        await catalog.paginatedAssets(taggedWith: tags, page: page)
    }

    public func listAssets(inLifecycle stage: InventoryLifecycleStage, page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<any InventoryAssetProtocol> {
        await catalog.paginatedAssets(inLifecycle: stage, page: page)
    }

    public func asset(identifierType: InventoryIdentifierType, value: String) async -> (any InventoryAssetProtocol)? {
        await catalog.asset(identifierType: identifierType, value: value)
    }
    
    public func evaluateRelationships(for assetID: UUID) async -> [InventoryRelationshipEvaluation] {
        await catalog.evaluateRelationships(forAssetID: assetID)
    }
}