import Foundation

/// Protocol representing a Manufacturer (Creator/Publisher) entity.
/// Allows for various storage implementations (CloudKit, SwiftData, etc.).
public protocol InventoryManufacturer: Sendable {
    var id: UUID { get }
    var name: String { get }
    
    /// Alternate names or aliases (e.g., "Apple Computer, Inc.", "Apple").
    var aliases: [String] { get }
    
    /// Also known as names (e.g. "Big Blue" for IBM).
    var alsoKnownAs: [String] { get }
    
    /// Alternative spellings (e.g. "Micro-Soft" vs "Microsoft").
    var alternativeSpellings: [String] { get }
    
    /// Common misspellings to assist search (e.g. "Nitendo").
    var commonMisspellings: [String] { get }
    
    /// Physical address or headquarters history.
    /// Physical address or headquarters history.
    var addresses: [Address] { get }
    
    /// Contact email address.
    var email: String? { get }
    
    /// Key principals, founders, or notable people.
    var associatedPeople: [Contact] { get }
    
    /// Associated developers or engineering teams.
    var developers: [Contact] { get }
    
    /// Description or history of the manufacturer.
    var description: String? { get }
    
    /// Metadata dictionary for untyped/dynamic attributes.
    var metadata: [String: String] { get }
}
