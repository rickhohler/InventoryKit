import Foundation

/// Protocol for Manufacturer/Publisher questionnaires.
public protocol ManufacturerQuestionnaire: Sendable, Codable {
    /// Generates key-value attributes for the manufacturer.
    func generateAttributes() -> [String: String]
    
    /// Generates tags for the manufacturer.
    func generateTags() -> [String]
    
    /// Returns a list of localized labels for the questions/fields.
    var localizedQuestions: [String: String] { get }
}

/// Questionnaire for Software Publishers.
public struct SoftwarePublisherQuestionnaire: ManufacturerQuestionnaire {
    public var isIndie: Bool
    public var primaryRegion: String?
    public var notablePlatforms: [String] // e.g. ["Apple II", "C64"]
    public var status: CompanyStatus
    
    public enum CompanyStatus: String, Codable, Sendable, CaseIterable {
        case active = "Active"
        case defunct = "Defunct"
        case acquired = "Acquired"
        case merged = "Merged"
    }
    
    public init(
        isIndie: Bool = false,
        primaryRegion: String? = nil,
        notablePlatforms: [String] = [],
        status: CompanyStatus = .defunct
    ) {
        self.isIndie = isIndie
        self.primaryRegion = primaryRegion
        self.notablePlatforms = notablePlatforms
        self.status = status
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        tags.append(InventoryTag.Manufacturer.publisher.rawValue)
        if isIndie { tags.append(InventoryTag.Manufacturer.indie.rawValue) }
        
        switch status {
        case .active: tags.append(InventoryTag.Manufacturer.active.rawValue)
        case .defunct: tags.append(InventoryTag.Manufacturer.defunct.rawValue)
        case .acquired: tags.append(InventoryTag.Manufacturer.acquired.rawValue)
        case .merged: tags.append(InventoryTag.Manufacturer.merged.rawValue)
        }
        
        // Platforms are dynamic, so we keep them or prefix them?
        // Let's prefix them with "platform:" to be safe namespaced
        for p in notablePlatforms {
            tags.append("platform:\(p.lowercased())")
        }
        
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        attrs["type"] = "Software Publisher"
        attrs["is_indie"] = String(isIndie)
        attrs["status"] = status.rawValue
        if let reg = primaryRegion { attrs["region"] = reg }
        attrs["platforms"] = notablePlatforms.joined(separator: ", ")
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "isIndie": NSLocalizedString("question.isIndie", bundle: .inventoryKit, value: "Is this an Indie developer?", comment: "Question: Indie"),
            "primaryRegion": NSLocalizedString("question.primaryRegion", bundle: .inventoryKit, value: "Primary Region:", comment: "Question: Region"),
            "notablePlatforms": NSLocalizedString("question.notablePlatforms", bundle: .inventoryKit, value: "Notable Platforms (comma separated):", comment: "Question: Platforms"),
            "status": NSLocalizedString("question.companyStatus", bundle: .inventoryKit, value: "Company Status:", comment: "Question: Status")
        ]
    }
}

/// Questionnaire for Hardware Manufacturers.
public struct HardwareManufacturerQuestionnaire: ManufacturerQuestionnaire {
    public var manufacturerType: HardwareType
    public var primaryRegion: String?
    public var status: CompanyStatus
    
    public enum HardwareType: String, Codable, Sendable, CaseIterable {
        case computer = "Computer Systems"
        case peripherals = "Peripherals"
        case components = "Components" // Chips, Boards
        case accessories = "Accessories" // Cables, Cases
    }
    
    public enum CompanyStatus: String, Codable, Sendable, CaseIterable {
        case active = "Active"
        case defunct = "Defunct"
        case acquired = "Acquired"
    }
    
    public init(
        manufacturerType: HardwareType = .peripherals,
        primaryRegion: String? = nil,
        status: CompanyStatus = .defunct
    ) {
        self.manufacturerType = manufacturerType
        self.primaryRegion = primaryRegion
        self.status = status
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        tags.append(InventoryTag.Manufacturer.hardware.rawValue)
        
        // Map hardware type
        switch manufacturerType {
        case .computer: tags.append("type:computer") // Add to enum later if needed
        case .peripherals: tags.append("type:peripheral")
        case .components: tags.append("type:component")
        case .accessories: tags.append("type:accessory")
        }
        
        switch status {
        case .active: tags.append(InventoryTag.Manufacturer.active.rawValue)
        case .defunct: tags.append(InventoryTag.Manufacturer.defunct.rawValue)
        case .acquired: tags.append(InventoryTag.Manufacturer.acquired.rawValue)
        }
        
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        attrs["type"] = "Hardware Manufacturer"
        attrs["hardware_category"] = manufacturerType.rawValue
        attrs["status"] = status.rawValue
        if let reg = primaryRegion { attrs["region"] = reg }
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "manufacturerType": NSLocalizedString("question.manufacturerType", bundle: .inventoryKit, value: "Type of Hardware Manufacturer:", comment: "Question: Hardware Type"),
            "primaryRegion": NSLocalizedString("question.primaryRegion", bundle: .inventoryKit, value: "Primary Region:", comment: "Question: Region"),
            "status": NSLocalizedString("question.companyStatus", bundle: .inventoryKit, value: "Company Status:", comment: "Question: Status")
        ]
    }
}
