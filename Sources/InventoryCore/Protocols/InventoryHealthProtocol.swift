import Foundation

/// Captures the physical and operational state of an asset.
/// Captures the physical and operational state of an asset.
public protocol InventoryHealthProtocol: Sendable {
    var physicalCondition: InventoryPhysicalCondition { get }
    var operationalStatus: InventoryOperationalStatus { get }
    var notes: String? { get }
    var lastDiagnosticAt: Date? { get }
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
