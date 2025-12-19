//
//  InventoryProduct.swift
//  InventoryKit
//
//  Product (Authority Record) model for software titles and hardware products
//

import Foundation
import InventoryCore

/// Product (Authority Record) representing a software title or hardware product.
///
/// Products are catalog entries that serve as authority records, linking to user assets
/// via `productID` references. Products use `InventoryIdentifier` for product codes (UPC, etc.).
///
/// ## Protocol Conformance
///
/// Conforms to `InventoryProductProtocol` which composes:
/// - `InventoryProductIdentificationProtocol` - Core identification
/// - `InventoryProductMetadataProtocol` - Basic metadata
/// - `InventoryProductCreatorProtocol` - Creator/publisher information
/// - `InventoryProductSpecificationProtocol` - Specifications
///
/// ## Single Responsibility Principle (SRP)
///
/// This model focuses on core product data. Separate concerns are handled by:
/// - `InventoryProductProvenance` (optional) - Acquisition, ownership history
/// - `InventoryProductExhibition` (optional) - Exhibition history
/// - Industry references and resource links remain in RetroInventoryKit (catalog-specific)
///
/// ## Usage
///
/// ```swift
/// let product = InventoryProduct(
///     title: "Apple IIe",
///     productType: .hardware,
///     manufacturer: "Apple",
///     identifiers: [
///         InventoryIdentifier(type: .upc, value: "012345678901")
///     ]
/// )
/// ```
///
/// - SeeAlso: ``InventoryProductProtocol``
/// - SeeAlso: ``InventoryProductProvenance``
/// - SeeAlso: ``InventoryProductExhibition``
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProduct: InventoryProductProtocol, Identifiable, Sendable, Codable, Equatable, Hashable {
    // MARK: - Identification (InventoryProductIdentificationProtocol)
    
    /// Unique identifier for the Product
    public let id: UUID
    
    /// Museum-style accession number (optional)
    public let accessionNumber: String?
    
    // MARK: - Metadata (InventoryProductMetadataProtocol)
    
    /// Product title (e.g., "Championship Lode Runner")
    public let title: String
    
    /// Product type (software or hardware)
    public let productType: ProductType
    
    /// Product description
    public let description: String?
    
    /// Classification from Nomenclature 4.0 or other controlled vocabulary
    public let classification: String?
    
    // MARK: - Creator Information (InventoryProductCreatorProtocol)
    
    /// Manufacturer name (for hardware) or publisher (for software)
    public let manufacturer: String?
    
    /// Publisher name (for software)
    public let publisher: String?
    
    /// Developer name
    public let developer: String?
    
    /// Individual creator/designer
    public let creator: String?
    
    // MARK: - Temporal Information
    
    /// Release date
    public let releaseDate: Date?
    
    /// Production date
    public let productionDate: Date?
    
    // MARK: - Specifications (InventoryProductSpecificationProtocol)
    
    /// Platform (e.g., "Apple II", "Commodore 64")
    public let platform: String?
    
    /// System requirements (for software) or general technical info
    public let systemRequirements: String?
    
    /// Software version (for software products)
    public let version: String?
    
    /// Genre or category (for software products)
    public let genre: String?
    
    /// Model numbers for hardware products (e.g., "A2S2000" for Apple IIe)
    public let modelNumbers: [String]
    
    /// Hardware specifications (CPU, RAM, storage, ports, etc.)
    public let hardwareSpecs: HardwareSpecification?
    
    /// Hardware features (e.g., "80-column card", "Extended 80-column card", "RGB monitor support")
    public let features: [String]
    
    // MARK: - Product Identifiers
    
    /// Product identifiers (UPC, etc.) using InventoryIdentifier
    public let identifiers: [InventoryIdentifier]
    
    // MARK: - Optional Extensions (SRP - Separated Concerns)
    
    /// Provenance information (acquisition, ownership history) - optional
    public let provenance: InventoryProductProvenance?
    
    /// Exhibition history - optional
    public let exhibition: InventoryProductExhibition?
    
    // MARK: - Metadata
    
    /// Extended metadata
    public let metadata: [String: String]
    
    // MARK: - Timestamps
    
    /// Creation date
    public let createdAt: Date
    
    /// Last modification date
    public let modifiedAt: Date
    
    public init(
        id: UUID = UUID(),
        accessionNumber: String? = nil,
        title: String,
        productType: ProductType,
        description: String? = nil,
        classification: String? = nil,
        manufacturer: String? = nil,
        publisher: String? = nil,
        developer: String? = nil,
        creator: String? = nil,
        releaseDate: Date? = nil,
        productionDate: Date? = nil,
        platform: String? = nil,
        systemRequirements: String? = nil,
        version: String? = nil,
        genre: String? = nil,
        modelNumbers: [String] = [],
        hardwareSpecs: HardwareSpecification? = nil,
        features: [String] = [],
        identifiers: [InventoryIdentifier] = [],
        provenance: InventoryProductProvenance? = nil,
        exhibition: InventoryProductExhibition? = nil,
        metadata: [String: String] = [:],
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.accessionNumber = accessionNumber
        self.title = title
        self.productType = productType
        self.description = description
        self.classification = classification
        self.manufacturer = manufacturer
        self.publisher = publisher
        self.developer = developer
        self.creator = creator
        self.releaseDate = releaseDate
        self.productionDate = productionDate
        self.platform = platform
        self.systemRequirements = systemRequirements
        self.version = version
        self.genre = genre
        self.modelNumbers = modelNumbers
        self.hardwareSpecs = hardwareSpecs
        self.features = features
        self.identifiers = identifiers
        self.provenance = provenance
        self.exhibition = exhibition
        self.metadata = metadata
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}

/// Provenance information for products (acquisition, ownership history).
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProductProvenance: Sendable, Codable, Hashable {
    /// Acquisition date
    public let acquisitionDate: Date?
    
    /// Acquisition source (donor, purchase, etc.)
    public let acquisitionSource: String?
    
    /// Ownership history
    public let provenance: String?
    
    /// Physical condition
    public let condition: String?
    
    /// Storage location
    public let location: String?
    
    public init(
        acquisitionDate: Date? = nil,
        acquisitionSource: String? = nil,
        provenance: String? = nil,
        condition: String? = nil,
        location: String? = nil
    ) {
        self.acquisitionDate = acquisitionDate
        self.acquisitionSource = acquisitionSource
        self.provenance = provenance
        self.condition = condition
        self.location = location
    }
}

/// Exhibition history for products.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProductExhibition: Sendable, Codable, Hashable {
    /// Exhibition records
    public let exhibitionHistory: [ExhibitionRecord]
    
    public init(exhibitionHistory: [ExhibitionRecord] = []) {
        self.exhibitionHistory = exhibitionHistory
    }
}

