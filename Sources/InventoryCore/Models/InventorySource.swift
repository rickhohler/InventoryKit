import Foundation

/// Represents the source or provenance of an asset.
public struct InventorySource: Codable, Equatable, Hashable, Sendable {
    public var origin: String
    public var department: String?
    public var contactEmail: String?
    public var contactPhone: String?

    public init(
        origin: String,
        department: String? = nil,
        contactEmail: String? = nil,
        contactPhone: String? = nil
    ) {
        self.origin = origin
        self.department = department
        self.contactEmail = contactEmail
        self.contactPhone = contactPhone
    }
}
