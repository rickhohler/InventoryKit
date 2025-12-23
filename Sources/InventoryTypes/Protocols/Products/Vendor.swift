// InventoryKit Library
// Vendor Protocol
//
// This file defines a protocol for vendor information that can be adopted by clients.
// The same protocol exists in FileSystemKit to ensure compatibility across libraries.

import Foundation

/// Protocol defining vendor information for InventoryKit.
///
/// This protocol allows clients to implement their own vendor models while maintaining
/// compatibility with InventoryKit. Vendors represent companies or organizations that
/// create products, file formats, or provide services.
///
/// ## Client Adoption
///
/// Clients can create their own vendor types that conform to this protocol:
///
/// ```swift
/// struct Vendor: Vendor {
///     var id: UUID
///     var name: String
///     var address: VendorAddress?
///     var inceptionDate: Date?
///     var websites: [URL]
///     // ... implement all protocol requirements
/// }
/// ```
///
/// ## Cross-Library Compatibility
///
/// A similar protocol (`FSVendorProtocol`) exists in FileSystemKit, ensuring that vendor
/// information can be shared between InventoryKit (for asset tracking) and FileSystemKit
/// (for file format metadata). Both protocols have the same structure for compatibility.
///
/// - SeeAlso: ``VendorAddress`` for structured address information
/// - SeeAlso: `FSVendorProtocol` in FileSystemKit for file system vendor information
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Vendor: Identifiable, Sendable where ID == UUID {
    /// Unique identifier for the vendor.
    var id: UUID { get set }
    
    /// Vendor name (company or organization name).
    /// Example: "Apple Computer", "Commodore Business Machines", "Microsoft Corporation"
    var name: String { get set }
    
    /// Structured address information.
    /// nil if address is unknown or not applicable.
    var address: (any Address)? { get set }
    
    /// Inception date - when the vendor was founded or established.
    /// nil if the date is unknown.
    var inceptionDate: Date? { get set }
    
    /// Website URLs - official website, Wikipedia page, etc.
    /// Can include multiple URLs (main site, Wikipedia, company history, etc.).
    /// Empty array if no websites are available.
    var websites: [URL] { get set }
    
    /// Contact email address.
    /// nil if not available or not applicable.
    var contactEmail: String? { get set }
    
    /// Contact phone number.
    /// nil if not available or not applicable.
    var contactPhone: String? { get set }
    
    /// Additional metadata dictionary.
    /// Can include industry, country, parent company, etc.
    var metadata: [String: String] { get set }
}
