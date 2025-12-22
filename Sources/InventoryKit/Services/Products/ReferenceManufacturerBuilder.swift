import Foundation
import InventoryCore

/// Builder for creating Authority Records for Manufacturers (Reference Manufacturers).
public class ReferenceManufacturerBuilder {
    private var id: UUID
    private var name: String
    private var aliases: [String] = []
    private var website: URL?
    private var description: String?
    
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
    
    public func build() throws -> any InventoryManufacturer {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw InventoryValidationError.missingRequiredField(field: "name", reason: "Manufacturer name cannot be empty.")
        }
        
        return PrivateManufacturerImpl(
            id: id,
            name: name,
            aliases: aliases,
            description: description,
            website: website
        )
    }
}

// MARK: - Private Implementation

private struct PrivateManufacturerImpl: InventoryManufacturer {
    var id: UUID
    var name: String
    var aliases: [String]
    var description: String?
    var country: String? = nil
    var website: URL?
    var foundedYear: Int? = nil
    var dissolvedYear: Int? = nil
    var metadata: [String : String] = [:]
    var logo: (any InventoryItem)? = nil
}
