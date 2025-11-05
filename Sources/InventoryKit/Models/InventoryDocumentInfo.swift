import Foundation

/// Optional metadata describing the origin of an inventory document.
public struct InventoryDocumentInfo: Codable, Equatable, Sendable {
    public var generatedAt: Date?
    public var source: String?
    public var summary: String?

    public init(generatedAt: Date? = nil, source: String? = nil, summary: String? = nil) {
        self.generatedAt = generatedAt
        self.source = source
        self.summary = summary
    }
}
