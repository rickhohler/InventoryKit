import Foundation

/// High-level SDK entry point that wires a storage provider, catalog, and logging together.
///
/// `InventoryService` provides a unified interface for managing inventory operations,
/// combining storage persistence, catalog indexing, and logging into a single actor.
/// Use the static `bootstrap(configuration:)` method to create a configured service instance.
///
/// ## Usage
///
/// ```swift
/// // Implement a storage provider (e.g., using FileSystemKit)
/// struct MyStorageProvider: InventoryStorageProvider {
///     let identifier = "my-provider"
///     let transformer = InventoryKit.transformer(for: .yaml)
///     // ... implement loadInventory and saveInventory
/// }
/// let provider = MyStorageProvider()
/// let configuration = InventoryConfiguration(
///     provider: provider,
///     schemaVersion: .current,
///     logLevel: .info
/// )
/// let service = try await InventoryService.bootstrap(configuration: configuration)
///
/// // Use the service to manage assets
/// await service.catalog.upsert(asset)
/// try await service.persistChanges()
/// ```
///
/// ## Thread Safety
///
/// `InventoryService` is an actor, ensuring thread-safe access to all operations.
/// All methods are safe to call from any concurrency context.
///
/// - SeeAlso: ``InventoryConfiguration`` for configuration options
/// - SeeAlso: ``InventoryCatalog`` for catalog operations
/// - SeeAlso: ``InventoryStorageProvider`` for storage provider implementations
/// - SeeAlso: [Apple Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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

    /// Bootstraps a new `InventoryService` instance with the provided configuration.
    ///
    /// This factory method creates a fully configured service by:
    /// 1. Initializing a logger with the configured log level
    /// 2. Loading the inventory document from the storage provider
    /// 3. Creating an `InventoryCatalog` with the loaded assets
    /// 4. Initializing the tag registry (default or custom)
    ///
    /// - Parameter configuration: The configuration specifying storage provider, schema version, and logging
    /// - Returns: A fully configured `InventoryService` instance
    /// - Throws: `InventoryError` if loading the inventory fails or schema validation fails
    ///
    /// - SeeAlso: ``InventoryConfiguration``
    /// - SeeAlso: ``InventoryCatalog``
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

    /// Lists assets with pagination, returning concrete `InventoryAsset` types.
    ///
    /// For protocol-based access, use `catalog.paginatedAssets(page:)` directly.
    public func listAssets(page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<InventoryAsset> {
        await catalog.paginatedConcreteAssets(page: page)
    }

    public func listAssets(taggedWith tags: Set<String>, page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<InventoryAsset> {
        let protocolPage = await catalog.paginatedAssets(taggedWith: tags, page: page)
        return InventoryPage(
            items: protocolPage.items.map { convertToConcrete($0) },
            nextOffset: protocolPage.nextOffset,
            total: protocolPage.total
        )
    }

    public func listAssets(inLifecycle stage: InventoryLifecycleStage, page: InventoryPageRequest = InventoryPageRequest()) async -> InventoryPage<InventoryAsset> {
        let protocolPage = await catalog.paginatedAssets(inLifecycle: stage, page: page)
        return InventoryPage(
            items: protocolPage.items.map { convertToConcrete($0) },
            nextOffset: protocolPage.nextOffset,
            total: protocolPage.total
        )
    }

    public func asset(identifierType: InventoryIdentifierType, value: String) async -> InventoryAsset? {
        guard let protocolAsset = await catalog.asset(identifierType: identifierType, value: value) else {
            return nil
        }
        return convertToConcrete(protocolAsset)
    }
    
    /// Helper to convert protocol asset to concrete InventoryAsset.
    private func convertToConcrete(_ asset: any InventoryAssetProtocol) -> InventoryAsset {
        InventoryAsset(
            id: asset.id,
            name: asset.name,
            type: asset.type,
            location: asset.location,
            source: asset.source,
            lifecycle: asset.lifecycle,
            mro: asset.mro,
            health: asset.health,
            components: asset.components,
            relationshipRequirements: asset.relationshipRequirements,
            linkedAssets: asset.linkedAssets,
            identifiers: asset.identifiers,
            tags: asset.tags,
            metadata: asset.metadata
        )
    }

    public func evaluateRelationships(for assetID: UUID) async -> [InventoryRelationshipEvaluation] {
        await catalog.evaluateRelationships(forAssetID: assetID)
    }
}
