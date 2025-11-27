import Foundation

/// High-level SDK entry point that wires a storage provider, catalog, and logging together.
public actor InventoryService {
    public let configuration: InventoryConfiguration
    public let catalog: InventoryCatalog
    /// Tag registry for tag-based code execution.
    /// Defaults to `DefaultTagRegistry` if none provided in configuration.
    public let tagRegistry: any InventoryTagRegistry

    private let logger: InventoryLogger

    private init(configuration: InventoryConfiguration, catalog: InventoryCatalog, logger: InventoryLogger, tagRegistry: any InventoryTagRegistry) {
        self.configuration = configuration
        self.catalog = catalog
        self.logger = logger
        self.tagRegistry = tagRegistry
    }

    public static func bootstrap(configuration: InventoryConfiguration) async throws -> InventoryService {
        let logger = InventoryLogger(level: configuration.logLevel)
        logger.info("Bootstrapping inventory via provider \(configuration.provider.identifier)")
        let document = try await configuration.provider.loadInventory(validatingAgainst: configuration.schemaVersion)
        logger.debug("Loaded \(document.assets.count) assets")
        let catalog = InventoryCatalog(document: document)
        
        // Initialize tag registry: use provided one or create default
        let tagRegistry: any InventoryTagRegistry = configuration.tagRegistry ?? DefaultTagRegistry()
        
        return InventoryService(configuration: configuration, catalog: catalog, logger: logger, tagRegistry: tagRegistry)
    }

    public func refreshFromProvider() async throws {
        logger.info("Refreshing inventory from provider \(configuration.provider.identifier)")
        let document = try await configuration.provider.loadInventory(validatingAgainst: configuration.schemaVersion)
        await catalog.replaceDocument(document)
        logger.debug("Catalog replaced with \(document.assets.count) assets")
    }

    public func persistChanges() async throws {
        logger.info("Persisting inventory via provider \(configuration.provider.identifier)")
        let document = await catalog.snapshotDocument()
        try await configuration.provider.saveInventory(document)
        logger.debug("Persisted \(document.assets.count) assets")
    }

    // MARK: Convenience APIs

    public func listAssets(page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<InventoryAsset> {
        await catalog.paginatedAssets(page: page)
    }

    public func listAssets(taggedWith tags: Set<String>, page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<InventoryAsset> {
        await catalog.paginatedAssets(taggedWith: tags, page: page)
    }

    public func listAssets(inLifecycle stage: InventoryLifecycleStage, page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<InventoryAsset> {
        await catalog.paginatedAssets(inLifecycle: stage, page: page)
    }

    public func asset(identifierType: InventoryIdentifierType, value: String) async -> InventoryAsset? {
        await catalog.asset(identifierType: identifierType, value: value)
    }

    public func evaluateRelationships(for assetID: UUID) async -> [InventoryRelationshipEvaluation] {
        await catalog.evaluateRelationships(forAssetID: assetID)
    }
}
