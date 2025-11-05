import Foundation

/// Captures the physical and operational state of an asset.
public struct InventoryHealth: Codable, Equatable, Hashable, Sendable {
    public var physicalCondition: InventoryPhysicalCondition
    public var operationalStatus: InventoryOperationalStatus
    public var notes: String?
    public var lastDiagnosticAt: Date?

    public init(
        physicalCondition: InventoryPhysicalCondition = .unknown,
        operationalStatus: InventoryOperationalStatus = .unknown,
        notes: String? = nil,
        lastDiagnosticAt: Date? = nil
    ) {
        self.physicalCondition = physicalCondition
        self.operationalStatus = operationalStatus
        self.notes = notes
        self.lastDiagnosticAt = lastDiagnosticAt
    }
}

public enum InventoryPhysicalCondition: String, Codable, Sendable {
    case excellent
    case good
    case fair
    case poor
    case damaged
    case unknown
}

public enum InventoryOperationalStatus: String, Codable, Sendable {
    case working
    case degraded
    case inoperative
    case maintenance
    case unknown
}
