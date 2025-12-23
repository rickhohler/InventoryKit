import Foundation
import InventoryTypes
import InventoryCore

/// Builder for creating Authority Records for Manufacturers (Reference Manufacturers).
public class ReferenceManufacturerBuilder {
    private var id: UUID
    private var name: String
    private var aliases: [String] = []
    private var website: URL?
    private var description: String?
    private var metadata: [String: String] = [:]
    
    public init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    public func setID(_ id: UUID) -> Self {
        self.id = id
        return self
    }
    
    public func addAlias(_ alias: String) -> Self {
        self.aliases.append(alias)
        return self
    }
    
    public func setWebsite(_ url: URL) -> Self {
        self.website = url
        return self
    }
    
    public func setDescription(_ description: String) -> Self {
        self.description = description
        return self
    }
    
    public func addMetadata(_ key: String, _ value: String) -> Self {
        self.metadata[key] = value
        return self
    }
    
    public func applyQuestionnaire(_ questionnaire: any ManufacturerQuestionnaire) -> Self {
        let attrs = questionnaire.generateAttributes()
        self.metadata.merge(attrs) { (_, new) in new }
        // Note: Manufacturers don't strictly have "Tags" in their protocol yet, but they have metadata.
        // If we add tags later, we can map them here.
        return self
    }
    
    public func build() throws -> any Manufacturer {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw InventoryValidationError.missingRequiredField(field: "name", reason: "Manufacturer name cannot be empty.")
        }
        
        let computedSlug = name.lowercased().replacingOccurrences(of: " ", with: "-")
        
        return PrivateManufacturerImpl(
            id: id,
            name: name,
            slug: computedSlug,
            aliases: aliases,
            description: description,
            website: website,
            metadata: metadata
        )
    }
}

// MARK: - Private Implementation

private struct PrivateManufacturerImpl: ReferenceManufacturer {
    var id: UUID
    var name: String
    var slug: String
    var aliases: [String]
    var description: String?
    var country: String? = nil
    var website: URL?
    var email: String? = nil
    var foundedYear: Int? = nil
    var dissolvedYear: Int? = nil
    var metadata: [String : String] = [:]
    
    // Additional Protocol Requirements
    var alsoKnownAs: [String] = []
    var alternativeSpellings: [String] = []
    var commonMisspellings: [String] = []
    
    var addresses: [any Address] = []
    var associatedPeople: [any Contact] = []
    var developers: [any Contact] = []
    
    var images: [ReferenceItem] = []
}
