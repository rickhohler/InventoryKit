import Foundation
import InventoryCore

// MARK: - Manufacturer

/// Type-erased wrapper for `InventoryManufacturerProtocol`.
public struct AnyInventoryManufacturer: InventoryManufacturerProtocol, Identifiable, Sendable, Codable {
    public let id: UUID
    public let name: String
    public let aliases: [String]
    public let description: String?
    
    public init(_ manufacturer: any InventoryManufacturerProtocol) {
        self.id = manufacturer.id
        self.name = manufacturer.name
        self.aliases = manufacturer.aliases
        self.description = manufacturer.description
    }
    
    public init(id: UUID, name: String, aliases: [String] = [], description: String? = nil) {
        self.id = id
        self.name = name
        self.aliases = aliases
        self.description = description
    }
}

// MARK: - Product

/// Type-erased wrapper for `InventoryProductProtocol`.
public struct AnyInventoryProduct: InventoryProductProtocol, Identifiable, Sendable, Codable {
    public let id: UUID

    // But for Codable, we need concrete?
    // InventoryIdentifier from ConcreteInventoryModels is available in this module.
    // We will store as concrete internally.
    private let _identifiers: [InventoryIdentifier]
    public var identifiers: [any InventoryIdentifierProtocol] { _identifiers }
    
    public let sku: String?
    
    // Legacy / Shared
    public let title: String
    public let description: String?
    public let productType: String?
    public let classification: String?
    public let genre: String?
    
    public let manufacturerRecord: AnyInventoryManufacturer?
    public var manufacturer: (any InventoryManufacturerProtocol)? { manufacturerRecord }
    
    public let publisher: String?
    public let developer: String?
    public let creator: String?
    
    public let releaseDate: Date?
    public let productionDate: Date?
    
    public let platform: String?
    public let systemRequirements: String?
    public let version: String?
    
    public let instanceIDs: [UUID]
    public let artworkIDs: [UUID]
    public let screenshotIDs: [UUID]
    public let instructionIDs: [UUID]
    public let collectionIDs: [UUID]
    
    public let references: [String: String]
    public let metadata: [String: String]
    
    public init(_ product: any InventoryProductProtocol) {
        self.id = product.id
        self._identifiers = product.identifiers.compactMap { $0 as? InventoryIdentifier ?? InventoryIdentifier(type: $0.type, value: $0.value) }
        self.sku = product.sku
        self.title = product.title
        self.description = product.description
        self.productType = product.productType
        self.classification = product.classification
        self.genre = product.genre
        
        if let man = product.manufacturer {
            self.manufacturerRecord = AnyInventoryManufacturer(man)
        } else {
            self.manufacturerRecord = nil
        }
        
        self.publisher = product.publisher
        self.developer = product.developer
        self.creator = product.creator
        self.releaseDate = product.releaseDate
        self.productionDate = product.productionDate
        self.platform = product.platform
        self.systemRequirements = product.systemRequirements
        self.version = product.version
        self.instanceIDs = product.instanceIDs
        self.artworkIDs = product.artworkIDs
        self.screenshotIDs = product.screenshotIDs
        self.instructionIDs = product.instructionIDs
        self.collectionIDs = product.collectionIDs
        self.references = product.references
        self.metadata = product.metadata
    }
    
    // Explicit init
    public init(
        id: UUID = UUID(),
        identifiers: [InventoryIdentifier] = [],
        sku: String? = nil,
        title: String,
        description: String? = nil,
        productType: String? = nil,
        classification: String? = nil,
        genre: String? = nil,
        manufacturer: AnyInventoryManufacturer? = nil,
        publisher: String? = nil,
        developer: String? = nil,
        creator: String? = nil,
        releaseDate: Date? = nil,
        productionDate: Date? = nil,
        platform: String? = nil,
        systemRequirements: String? = nil,
        version: String? = nil,
        instanceIDs: [UUID] = [],
        artworkIDs: [UUID] = [],
        screenshotIDs: [UUID] = [],
        instructionIDs: [UUID] = [],
        collectionIDs: [UUID] = [],
        references: [String: String] = [:],
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self._identifiers = identifiers
        self.sku = sku
        self.title = title
        self.description = description
        self.productType = productType
        self.classification = classification
        self.genre = genre
        self.manufacturerRecord = manufacturer
        self.publisher = publisher
        self.developer = developer
        self.creator = creator
        self.releaseDate = releaseDate
        self.productionDate = productionDate
        self.platform = platform
        self.systemRequirements = systemRequirements
        self.version = version
        self.instanceIDs = instanceIDs
        self.artworkIDs = artworkIDs
        self.screenshotIDs = screenshotIDs
        self.instructionIDs = instructionIDs
        self.collectionIDs = collectionIDs
        self.references = references
        self.metadata = metadata
    }
    
    enum CodingKeys: String, CodingKey {
        case id, identifiers, sku, title, description, productType, classification, genre
        case manufacturerRecord = "manufacturer"
        case publisher, developer, creator
        case releaseDate, productionDate
        case platform, systemRequirements, version
        case instanceIDs, artworkIDs, screenshotIDs, instructionIDs, collectionIDs
        case references, metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self._identifiers = try container.decodeIfPresent([InventoryIdentifier].self, forKey: .identifiers) ?? []
        self.sku = try container.decodeIfPresent(String.self, forKey: .sku)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.productType = try container.decodeIfPresent(String.self, forKey: .productType)
        self.classification = try container.decodeIfPresent(String.self, forKey: .classification)
        self.genre = try container.decodeIfPresent(String.self, forKey: .genre)
        self.manufacturerRecord = try container.decodeIfPresent(AnyInventoryManufacturer.self, forKey: .manufacturerRecord)
        self.publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        self.developer = try container.decodeIfPresent(String.self, forKey: .developer)
        self.creator = try container.decodeIfPresent(String.self, forKey: .creator)
        self.releaseDate = try container.decodeIfPresent(Date.self, forKey: .releaseDate)
        self.productionDate = try container.decodeIfPresent(Date.self, forKey: .productionDate)
        self.platform = try container.decodeIfPresent(String.self, forKey: .platform)
        self.systemRequirements = try container.decodeIfPresent(String.self, forKey: .systemRequirements)
        self.version = try container.decodeIfPresent(String.self, forKey: .version)
        self.instanceIDs = try container.decodeIfPresent([UUID].self, forKey: .instanceIDs) ?? []
        self.artworkIDs = try container.decodeIfPresent([UUID].self, forKey: .artworkIDs) ?? []
        self.screenshotIDs = try container.decodeIfPresent([UUID].self, forKey: .screenshotIDs) ?? []
        self.instructionIDs = try container.decodeIfPresent([UUID].self, forKey: .instructionIDs) ?? []
        self.collectionIDs = try container.decodeIfPresent([UUID].self, forKey: .collectionIDs) ?? []
        self.references = try container.decodeIfPresent([String: String].self, forKey: .references) ?? [:]
        self.metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata) ?? [:]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if !_identifiers.isEmpty { try container.encode(_identifiers, forKey: .identifiers) }
        try container.encodeIfPresent(sku, forKey: .sku)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(productType, forKey: .productType)
        try container.encodeIfPresent(classification, forKey: .classification)
        try container.encodeIfPresent(genre, forKey: .genre)
        try container.encodeIfPresent(manufacturerRecord, forKey: .manufacturerRecord)
        try container.encodeIfPresent(publisher, forKey: .publisher)
        try container.encodeIfPresent(developer, forKey: .developer)
        try container.encodeIfPresent(creator, forKey: .creator)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(productionDate, forKey: .productionDate)
        try container.encodeIfPresent(platform, forKey: .platform)
        try container.encodeIfPresent(systemRequirements, forKey: .systemRequirements)
        try container.encodeIfPresent(version, forKey: .version) 
        if !instanceIDs.isEmpty { try container.encode(instanceIDs, forKey: .instanceIDs) }
        if !artworkIDs.isEmpty { try container.encode(artworkIDs, forKey: .artworkIDs) }
        if !screenshotIDs.isEmpty { try container.encode(screenshotIDs, forKey: .screenshotIDs) }
        if !instructionIDs.isEmpty { try container.encode(instructionIDs, forKey: .instructionIDs) }
        if !collectionIDs.isEmpty { try container.encode(collectionIDs, forKey: .collectionIDs) }
        if !references.isEmpty { try container.encode(references, forKey: .references) }
        if !metadata.isEmpty { try container.encode(metadata, forKey: .metadata) }
    }
}

// MARK: - Library Bundle & Delta

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct LibraryBundle: LibraryBundleProtocol, Sendable, Codable {
    public let bundleId: String
    public let bundleVersion: Int64
    public let createdAt: Date
    public let dataSnapshotDate: Date
    
    // Concrete products for Codable
    public var products: [any InventoryProductProtocol] { _products }
    private let _products: [AnyInventoryProduct]
    
    public init(
        bundleId: String,
        bundleVersion: Int64,
        createdAt: Date,
        dataSnapshotDate: Date,
        products: [AnyInventoryProduct]
    ) {
        self.bundleId = bundleId
        self.bundleVersion = bundleVersion
        self.createdAt = createdAt
        self.dataSnapshotDate = dataSnapshotDate
        self._products = products
    }
    
    enum CodingKeys: String, CodingKey {
        case bundleId, bundleVersion, createdAt, dataSnapshotDate, products
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bundleId = try container.decode(String.self, forKey: .bundleId)
        bundleVersion = try container.decode(Int64.self, forKey: .bundleVersion)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        dataSnapshotDate = try container.decode(Date.self, forKey: .dataSnapshotDate)
        _products = try container.decode([AnyInventoryProduct].self, forKey: .products)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bundleId, forKey: .bundleId)
        try container.encode(bundleVersion, forKey: .bundleVersion)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(dataSnapshotDate, forKey: .dataSnapshotDate)
        try container.encode(_products, forKey: .products)
    }
    
    public init(serializedData: Data) throws {
        // Placeholder for Protobuf, but for now assuming JSON or simple init
        // Just providing empty defaults or throwing
        throw InventoryError.notImplemented("Legacy serializedData init not implemented")
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct LibraryDelta: LibraryDeltaProtocol, Sendable, Codable {
    public let deltaId: String
    public let bundleId: String
    public let bundleVersion: Int64
    public let createdAt: Date
    public let fromDate: Date
    public let toDate: Date
    
    public var createdProducts: [any InventoryProductProtocol] { _createdProducts }
    private let _createdProducts: [AnyInventoryProduct]
    
    public var updatedProducts: [any InventoryProductProtocol] { _updatedProducts }
    private let _updatedProducts: [AnyInventoryProduct]
    
    public let deletedProductIds: [UUID]
    
    public init(
        deltaId: String,
        bundleId: String,
        bundleVersion: Int64,
        createdAt: Date,
        fromDate: Date,
        toDate: Date,
        createdProducts: [AnyInventoryProduct] = [],
        updatedProducts: [AnyInventoryProduct] = [],
        deletedProductIds: [UUID] = []
    ) {
        self.deltaId = deltaId
        self.bundleId = bundleId
        self.bundleVersion = bundleVersion
        self.createdAt = createdAt
        self.fromDate = fromDate
        self.toDate = toDate
        self._createdProducts = createdProducts
        self._updatedProducts = updatedProducts
        self.deletedProductIds = deletedProductIds
    }
    
    enum CodingKeys: String, CodingKey {
        case deltaId, bundleId, bundleVersion, createdAt, fromDate, toDate
        case createdProducts, updatedProducts, deletedProductIds
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deltaId = try container.decode(String.self, forKey: .deltaId)
        bundleId = try container.decode(String.self, forKey: .bundleId)
        bundleVersion = try container.decode(Int64.self, forKey: .bundleVersion)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        fromDate = try container.decode(Date.self, forKey: .fromDate)
        toDate = try container.decode(Date.self, forKey: .toDate)
        _createdProducts = try container.decode([AnyInventoryProduct].self, forKey: .createdProducts)
        _updatedProducts = try container.decode([AnyInventoryProduct].self, forKey: .updatedProducts)
        deletedProductIds = try container.decode([UUID].self, forKey: .deletedProductIds)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deltaId, forKey: .deltaId)
        try container.encode(bundleId, forKey: .bundleId)
        try container.encode(bundleVersion, forKey: .bundleVersion)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(fromDate, forKey: .fromDate)
        try container.encode(toDate, forKey: .toDate)
        try container.encode(_createdProducts, forKey: .createdProducts)
        try container.encode(_updatedProducts, forKey: .updatedProducts)
        try container.encode(deletedProductIds, forKey: .deletedProductIds)
    }
}
