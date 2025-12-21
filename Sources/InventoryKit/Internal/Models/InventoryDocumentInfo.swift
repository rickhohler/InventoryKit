import Foundation

/// Optional metadata describing the origin of an inventory document.
struct InventoryDocumentInfo: Codable, Equatable, Sendable {
    var generatedAt: Date?
    var source: String?
    var summary: String?

    init(generatedAt: Date? = nil, source: String? = nil, summary: String? = nil) {
        self.generatedAt = generatedAt
        self.source = source
        self.summary = summary
    }
}
