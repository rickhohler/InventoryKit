import Foundation
import InventoryCore

public struct MockReferenceManufacturer: ReferenceManufacturer, Sendable {
    public let id: UUID
    public let slug: String
    public let name: String
    public let aliases: [String]
    public let description: String?
    
    public init(id: UUID = UUID(), slug: String, name: String, aliases: [String] = [], description: String? = nil) {
        self.id = id
        self.slug = slug
        self.name = name
        self.aliases = aliases
        self.description = description
    }
}

public struct MockReferenceLibrary: ReferenceLibrary, Sendable {
    public let id: UUID
    public let name: String
    public let url: URL?
    public let transport: String?
    public let adapter: String?
    public let type: InventoryDataSourceType
    public let isVerified: Bool
    
    public init(id: UUID = UUID(), name: String, url: URL? = nil, transport: String? = nil, adapter: String? = nil, type: InventoryDataSourceType = .archive, isVerified: Bool = true) {
        self.id = id
        self.name = name
        self.url = url
        self.transport = transport
        self.adapter = adapter
        self.type = type
        self.isVerified = isVerified
    }
}

public struct MockReferenceProduct: ReferenceProduct, Sendable {
    // InventoryCompoundBase
    public let id: UUID
    public let title: String
    public let description: String?
    public let manufacturer: (any InventoryManufacturer)?
    public let releaseDate: Date?
    public let dataSource: (any InventoryDataSource)?
    public let children: [any InventoryItem]
    public let images: [any InventoryItem]
    
    // InventoryProduct
    public let sku: String?
    public let productType: String?
    public let classification: String?
    public let genre: String?
    public let publisher: String?
    public let developer: String?
    public let creator: String?
    public let productionDate: Date?
    public let platform: String?
    public let systemRequirements: String?
    public let version: String?
    public let identifiers: [any InventoryIdentifier]
    public let instanceIDs: [UUID]
    public let artworkIDs: [UUID]
    public let screenshotIDs: [UUID]
    public let instructionIDs: [UUID]
    public let collectionIDs: [UUID]
    public let references: [String: String]
    public let metadata: [String: String]
    
    // ReferenceProduct Specifics
    public let wikipediaUrl: URL?
    public let purchaseUrl: URL?
    public let originCountry: String?
    public let discontinuedYear: Int?
    public let platforms: [String]?
    public let copyrightRegistration: String?
    public let manualUrls: [URL]?
    
    // Protocol requirement for foreign key (override default to nil for authority)
    public var referenceProductID: InventoryIdentifier? { nil }

    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        manufacturer: (any InventoryManufacturer)? = nil,
        releaseDate: Date? = nil,
        dataSource: (any InventoryDataSource)? = nil,
        children: [any InventoryItem] = [],
        images: [any InventoryItem] = [],
        
        sku: String? = nil,
        productType: String? = "Software",
        classification: String? = nil,
        genre: String? = nil,
        publisher: String? = nil,
        developer: String? = nil,
        creator: String? = nil,
        productionDate: Date? = nil,
        platform: String? = nil,
        systemRequirements: String? = nil,
        version: String? = nil,
        identifiers: [any InventoryIdentifier] = [],
        
        wikipediaUrl: URL? = nil,
        purchaseUrl: URL? = nil,
        originCountry: String? = nil,
        discontinuedYear: Int? = nil,
        platforms: [String]? = nil,
        copyrightRegistration: String? = nil,
        manualUrls: [URL]? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.manufacturer = manufacturer
        self.releaseDate = releaseDate
        self.dataSource = dataSource
        self.children = children
        self.images = images
        
        self.sku = sku
        self.productType = productType
        self.classification = classification
        self.genre = genre
        self.publisher = publisher
        self.developer = developer
        self.creator = creator
        self.productionDate = productionDate
        self.platform = platform
        self.systemRequirements = systemRequirements
        self.version = version
        self.identifiers = identifiers
        
        self.instanceIDs = []
        self.artworkIDs = []
        self.screenshotIDs = []
        self.instructionIDs = []
        self.collectionIDs = []
        self.references = [:]
        self.metadata = [:]
        
        self.wikipediaUrl = wikipediaUrl
        self.purchaseUrl = purchaseUrl
        self.originCountry = originCountry
        self.discontinuedYear = discontinuedYear
        self.platforms = platforms
        self.copyrightRegistration = copyrightRegistration
        self.manualUrls = manualUrls
    }
}
