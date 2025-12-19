import Foundation

/// Describes a pagination request.
public struct InventoryPageRequest: Sendable, Equatable {
    public var offset: Int
    public var limit: Int

    public init(offset: Int = 0, limit: Int = 50) {
        self.offset = max(0, offset)
        self.limit = max(1, limit)
    }
}

/// Represents a paginated response.
public struct InventoryPage<T>: Sendable where T: Sendable {
    public let items: [T]
    public let nextOffset: Int?
    public let total: Int

    public init(items: [T], nextOffset: Int?, total: Int) {
        self.items = items
        self.nextOffset = nextOffset
        self.total = total
    }
}
