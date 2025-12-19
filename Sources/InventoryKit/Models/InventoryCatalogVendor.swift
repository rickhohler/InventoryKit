//
//  InventoryCatalogVendor.swift
//  InventoryKit
//
//  Approved catalog vendor model for catalog data sources
//

import Foundation
import InventoryCore

/// Approved catalog vendor providing catalog data and collections.
///
/// Catalog vendors are approved sources of catalog data. They may provide:
/// - Collections of products
/// - Product metadata
/// - Links to public resources (disk images, artwork, documentation)
///
/// Approved vendors are trusted sources that meet quality and reliability standards.
///
/// **Note**: This is distinct from `InventoryVendorProtocol` which is for manufacturers of physical assets.
///
/// ## Protocol Conformance
///
/// Conforms to `InventoryCatalogVendorProtocol` which composes:
/// - `InventoryCatalogVendorIdentificationProtocol` - Core identification
/// - `InventoryCatalogVendorMetadataProtocol` - Metadata
/// - `InventoryCatalogVendorApprovalProtocol` - Approval info
///
/// ## Usage
///
/// ```swift
/// let vendor = InventoryCatalogVendor(
///     name: "Archive.org",
///     vendorType: .archive,
///     websiteURL: URL(string: "https://archive.org"),
///     isApproved: true
/// )
/// ```
///
/// - SeeAlso: ``InventoryCatalogVendorProtocol``
/// - SeeAlso: ``InventoryVendorProtocol`` (for manufacturers of physical assets)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryCatalogVendor: InventoryCatalogVendorProtocol, Identifiable, Hashable, Sendable, Codable {
    // MARK: - Identification (InventoryCatalogVendorIdentificationProtocol)
    
    /// Unique identifier for the vendor
    public let id: UUID
    
    /// Vendor name
    public let name: String
    
    // MARK: - Metadata (InventoryCatalogVendorMetadataProtocol)
    
    /// Vendor description
    public let description: String?
    
    /// Vendor type (archive, museum, database, etc.)
    public let vendorType: CatalogVendorType
    
    /// Vendor website URL
    public let websiteURL: URL?
    
    /// Vendor API endpoint (if applicable)
    public let apiEndpoint: URL?
    
    /// Vendor contact information
    public let contactInfo: String?
    
    // MARK: - Approval (InventoryCatalogVendorApprovalProtocol)
    
    /// Vendor approval status
    public let isApproved: Bool
    
    /// Date vendor was approved
    public let approvedDate: Date?
    
    /// Approval authority (who approved this vendor)
    public let approvedBy: String?
    
    // MARK: - Metadata
    
    /// Vendor-specific metadata
    public let metadata: [String: String]
    
    // MARK: - Timestamps
    
    /// Creation date
    public let createdAt: Date
    
    /// Last modification date
    public let modifiedAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        vendorType: CatalogVendorType,
        websiteURL: URL? = nil,
        apiEndpoint: URL? = nil,
        isApproved: Bool = false,
        approvedDate: Date? = nil,
        approvedBy: String? = nil,
        contactInfo: String? = nil,
        metadata: [String: String] = [:],
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.vendorType = vendorType
        self.websiteURL = websiteURL
        self.apiEndpoint = apiEndpoint
        self.isApproved = isApproved
        self.approvedDate = approvedDate
        self.approvedBy = approvedBy
        self.contactInfo = contactInfo
        self.metadata = metadata
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}

