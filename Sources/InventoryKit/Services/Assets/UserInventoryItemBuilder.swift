import Foundation
import InventoryTypes
import InventoryCore

/// Builder for creating private inventory assets (User Custody).
public class UserInventoryItemBuilder: MetaDatableBuilder {
    public typealias QuestionnaireType = any InventoryQuestionnaire
    
    private var id: UUID
    private var name: String
    private var type: String?
    private var location: String?
    private var acquisitionSource: String?
    private var acquisitionDate: Date?
    private var metadata: [String: String] = [:]
    
    private var tags: [String] = []
    private var condition: String?
    private var provenance: String?
    private var manufacturer: (any Manufacturer)?
    private var children: [any InventoryItem] = []
    private var validator: (any InventoryValidationStrategy)?
    
    public init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    // ... setters ...
    
    public func withValidator(_ validator: any InventoryValidationStrategy) -> Self {
        self.validator = validator
        return self
    }

    public func setID(_ id: UUID) -> Self {
        self.id = id
        return self
    }
    
    public func setType(_ type: String) -> Self {
        self.type = type
        return self
    }
    
    public func setLocation(_ location: String) -> Self {
        self.location = location
        return self
    }
    
    public func setAcquisition(source: String, date: Date?) -> Self {
        self.acquisitionSource = source
        self.acquisitionDate = date
        return self
    }
    
    public func setCondition(_ condition: String) -> Self {
        self.condition = condition
        return self
    }
    
    public func setProvenance(_ provenance: String) -> Self {
        self.provenance = provenance
        return self
    }
    
    public func setManufacturer(_ manufacturer: any Manufacturer) -> Self {
        self.manufacturer = manufacturer
        return self
    }

    public func addChild(_ item: any InventoryItem) -> Self {
        self.children.append(item)
        return self
    }
    
    public func addTag(_ tag: String) -> Self {
        self.tags.append(tag)
        return self
    }
    
    public func addMetadata(_ key: String, _ value: String) -> Self {
        self.metadata[key] = value
        return self
    }
    
    public func applyQuestionnaire(_ questionnaire: any InventoryQuestionnaire) -> Self {
        let tags = questionnaire.generateTags()
        let attrs = questionnaire.generateAttributes()
        
        tags.forEach { let _ = self.addTag($0) }
        self.metadata.merge(attrs) { (_, new) in new }
        
        return self
    }
    
    public func build() throws -> any InventoryAsset {
        // Validation Logic
        
        // 1. Base Validation (Always applied)
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
             throw InventoryValidationError.missingRequiredField(field: "name", reason: "Asset name cannot be empty.")
        }
        
        // 2. Build the candidate asset
        let asset = UserAsset(
            id: id,
            name: name,
            manufacturer: manufacturer,
            children: children,
            type: type,
            custodyLocation: location,
            acquisitionSource: acquisitionSource,
            acquisitionDate: acquisitionDate,
            tags: tags,
            provenance: provenance,
            condition: condition,
            metadata: metadata
        )
        
        // 3. Strategy Validation (if provided)
        if let validator = validator {
            try validator.validate(asset)
        }
        
        return asset
    }
}
