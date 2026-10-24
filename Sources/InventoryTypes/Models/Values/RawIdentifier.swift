import Foundation

/// An identifier as stored: `{"type": "...", "value": "..."}`.
///
/// `type` is a free string, so kinds this library does not define (or legacy raw values such
/// as 1.x's `serialNumber`) decode without error and survive a round trip.
public struct RawIdentifier: Codable, Hashable, Sendable {
    public var type: String
    public var value: String

    public init(type: String, value: String) {
        self.type = type
        self.value = value
    }

    public init(_ type: IdentifierType, value: String) {
        self.init(type: type.rawValue, value: value)
    }

    /// The known identifier kind, mapping legacy 1.x raw values; nil for other kinds.
    public var identifierType: IdentifierType? {
        if let known = IdentifierType(rawValue: type) { return known }
        switch type {
        case "serialNumber": return .serialNumber
        default: return nil
        }
    }
}
