import Foundation

public protocol InventoryDocumentInfo: Sendable {
    var generatedAt: Date? { get }
    var source: String? { get }
    var summary: String? { get }
}
