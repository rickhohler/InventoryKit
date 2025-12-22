import Foundation
import InventoryCore

public struct MockHealth: InventoryHealth, Sendable {
    public var physicalCondition: InventoryPhysicalCondition
    public var operationalStatus: InventoryOperationalStatus
    public var notes: String?
    public var lastDiagnosticAt: Date?
    
    public init(physicalCondition: InventoryPhysicalCondition, operationalStatus: InventoryOperationalStatus, notes: String? = nil, lastDiagnosticAt: Date? = nil) {
        self.physicalCondition = physicalCondition
        self.operationalStatus = operationalStatus
        self.notes = notes
        self.lastDiagnosticAt = lastDiagnosticAt
    }
}

public struct MockMRO: InventoryMROInfo, Sendable {
    public var sku: String?
    public var vendor: String?
    public var quantityOnHand: Int
    public var reorderPoint: Int?
    public var reorderQuantity: Int?
    
    public init(sku: String? = nil, vendor: String? = nil, quantityOnHand: Int, reorderPoint: Int? = nil, reorderQuantity: Int? = nil) {
        self.sku = sku
        self.vendor = vendor
        self.quantityOnHand = quantityOnHand
        self.reorderPoint = reorderPoint
        self.reorderQuantity = reorderQuantity
    }
}

public struct MockCopyright: CopyrightInfo, Sendable {
    public var text: String?
    public var year: Int?
    public var holder: String?
    public var license: String?
    public var metadata: [String : String]
    
    public init(text: String? = nil, year: Int? = nil, holder: String? = nil, license: String? = nil, metadata: [String : String] = [:]) {
        self.text = text
        self.year = year
        self.holder = holder
        self.license = license
        self.metadata = metadata
    }
}

public struct MockComponentLink: InventoryComponentLink, Sendable {
    public var assetID: UUID
    public var quantity: Int
    public var note: String?
    
    public init(assetID: UUID, quantity: Int, note: String? = nil) {
        self.assetID = assetID
        self.quantity = quantity
        self.note = note
    }
}

public struct MockRelationshipRequirement: InventoryRelationshipRequirement, Sendable {
    public var name: String
    public var typeID: String
    public var required: Bool
    public var compatibleAssetIDs: [UUID]
    public var requiredTags: [String]
    public var complianceNotes: String?
    
    public init(name: String, typeID: String, required: Bool, compatibleAssetIDs: [UUID] = [], requiredTags: [String] = [], complianceNotes: String? = nil) {
        self.name = name
        self.typeID = typeID
        self.required = required
        self.compatibleAssetIDs = compatibleAssetIDs
        self.requiredTags = requiredTags
        self.complianceNotes = complianceNotes
    }
} 

public struct MockLinkedAsset: InventoryLinkedAsset, Sendable {
    public var assetID: UUID
    public var typeID: String
    public var note: String?
    
    public init(assetID: UUID, typeID: String, note: String? = nil) {
        self.assetID = assetID
        self.typeID = typeID
        self.note = note
    }
}
