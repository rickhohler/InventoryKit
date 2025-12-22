import Foundation
import InventoryCore

public struct MockProduct: InventoryProduct, Sendable {
    public var id: UUID
    public var sku: String?
    public var title: String
    public var description: String?
    public var productType: String?
    public var classification: String?
    public var genre: String?
    
    public var manufacturer: (any InventoryManufacturer)?
    public var publisher: String?
    public var developer: String?
    public var creator: String?
    
    public var releaseDate: Date?
    public var productionDate: Date?
    
    public var platform: String?
    public var systemRequirements: (any InventorySystemRequirements)?
    public var version: String?
    
    public let identifiers: [any InventoryIdentifier]
    
    public let instanceIDs: [UUID]
    public let artworkIDs: [UUID]
    public let screenshotIDs: [UUID]
    public let instructionIDs: [UUID]
    public let collectionIDs: [UUID]
    
    public let references: [String: String]
    public let metadata: [String: String]
    public var sourceCode: (any InventorySourceCode)? // Protocol Requirement
    
    public var referenceProductID: (any InventoryIdentifier)? // Protocol Requirement
    public var referenceProductID_v: (any InventoryIdentifier)? { referenceProductID } // for init convenience?
    
    // Legacy support for tests expecting 'name'
    public var name: String { title }
    
    public init(
        id: UUID = UUID(),
        sku: String? = nil,
        title: String,
        description: String? = nil,
        productType: String? = nil,
        classification: String? = nil,
        genre: String? = nil,
        manufacturer: (any InventoryManufacturer)? = nil,
        publisher: String? = nil,
        developer: String? = nil,
        creator: String? = nil,
        releaseDate: Date? = nil,
        productionDate: Date? = nil,
        platform: String? = nil,
        systemRequirements: (any InventorySystemRequirements)? = nil,
        version: String? = nil,
        identifiers: [any InventoryIdentifier] = [],
        instanceIDs: [UUID] = [],
        artworkIDs: [UUID] = [],
        screenshotIDs: [UUID] = [],
        instructionIDs: [UUID] = [],
        collectionIDs: [UUID] = [],
        references: [String: String] = [:],
        metadata: [String: String] = [:],
        sourceCode: (any InventorySourceCode)? = nil
    ) {
        self.id = id
        self.sku = sku
        self.title = title
        self.description = description
        self.productType = productType
        self.classification = classification
        self.genre = genre
        self.manufacturer = manufacturer
        self.publisher = publisher
        self.developer = developer
        self.creator = creator
        self.releaseDate = releaseDate
        self.productionDate = productionDate
        self.platform = platform
        self.systemRequirements = systemRequirements
        self.version = version
        self.identifiers = identifiers
        self.instanceIDs = instanceIDs
        self.artworkIDs = artworkIDs
        self.screenshotIDs = screenshotIDs
        self.instructionIDs = instructionIDs
        self.collectionIDs = collectionIDs
        self.references = references
        self.metadata = metadata
        self.sourceCode = sourceCode
    }
}
