import Foundation
import InventoryCore

/// Builder for creating Authority Records (Reference Products).
/// These represent the abstract "Ideal" version of a product, not a specific instance.
public class ReferenceProductBuilder {
    private var id: UUID
    private var title: String
    // Product Metadata
    private var platform: String?
    private var publisher: String?
    private var releaseDate: Date?
    private var manufacturer: (any InventoryManufacturer)?
    
    // Identifiers & References
    private var identifiers: [any InventoryIdentifier] = []
    private var metadata: [String: String] = [:]
    
    public init(title: String) {
        self.id = UUID()
        self.title = title
    }
    
    public func setID(_ id: UUID) -> Self {
        self.id = id
        return self
    }
    
    public func setPlatform(_ platform: String) -> Self {
        self.platform = platform
        return self
    }
    
    public func setPublisher(_ publisher: String) -> Self {
        self.publisher = publisher
        return self
    }
    
    public func setManufacturer(_ manufacturer: any InventoryManufacturer) -> Self {
        self.manufacturer = manufacturer
        return self
    }
    
    public func setReleaseDate(_ date: Date) -> Self {
        self.releaseDate = date
        return self
    }
    
    public func addIdentifier(type: InventoryIdentifierType, value: String) -> Self {
        // Simple internal mock struct for identifier until we have a public one or use MockIdentifier
        let id = SimpleIdentifier(type: type, value: value)
        self.identifiers.append(id)
        return self
    }
    
    public func addMetadata(_ key: String, _ value: String) -> Self {
        self.metadata[key] = value
        return self
    }
    
    public func setSourceCode(url: URL?, notes: String?) -> Self {
        if let url = url {
            self.metadata["sourceCodeUrl"] = url.absoluteString
        }
        if let notes = notes {
            self.metadata["sourceCodeNotes"] = notes
        }
        return self
    }
    
    public func applyQuestionnaire(_ questionnaire: any InventoryQuestionnaire) -> Self {
        let attrs = questionnaire.generateAttributes()
        self.metadata.merge(attrs) { (_, new) in new }
        return self
    }
    
    public func build() throws -> any InventoryProduct {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw InventoryValidationError.missingRequiredField(field: "title", reason: "Product title cannot be empty.")
        }
        
        return PrivateReferenceProductImpl(
            id: id,
            title: title,
            manufacturer: manufacturer,
            releaseDate: releaseDate,
             sourceCode: {
                if let urlStr = metadata["sourceCodeUrl"], let url = URL(string: urlStr) {
                    return SourceCode(url: url, notes: metadata["sourceCodeNotes"])
                }
                return nil
            }(),
            publisher: publisher,
            platform: platform,
            identifiers: identifiers,
            metadata: metadata
        )
    }
}

// MARK: - Private Implementations

private struct PrivateReferenceProductImpl: InventoryProduct {
    var id: UUID
    var title: String
    var description: String? = nil
    var manufacturer: (any InventoryManufacturer)?
    var releaseDate: Date?
    var dataSource: (any InventoryDataSource)? = nil
    var children: [any InventoryItem] = []
    var images: [any InventoryItem] = []
    
    // Product Protocol
    var sku: String? = nil
    var productType: String? = "Product"
    var classification: String? = nil
    var genre: String? = nil
    var sourceCode: SourceCode? = nil
    var publisher: String?
    var developer: String? = nil
    var creator: String? = nil
    var productionDate: Date? = nil
    var platform: String?
    var systemRequirements: String? = nil
    var version: String? = nil
    var identifiers: [any InventoryIdentifier]
    var instanceIDs: [UUID] = []
    var artworkIDs: [UUID] = []
    var screenshotIDs: [UUID] = []
    var instructionIDs: [UUID] = []
    var collectionIDs: [UUID] = []
    var references: [String : String] = [:]
    var metadata: [String : String] = [:]
    
    // Reference Protocol
    var referenceProductID: InventoryIdentifier? = nil
}

private struct SimpleIdentifier: InventoryIdentifier, Sendable {
    var type: InventoryIdentifierType
    var value: String
}
