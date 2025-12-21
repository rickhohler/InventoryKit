import Foundation

/// Describes a pagination request.
struct InventoryPageRequest: Sendable, Equatable {
    var offset: Int
    var limit: Int

    init(offset: Int = 0, limit: Int = 50) {
        self.offset = max(0, offset)
        self.limit = max(1, limit)
    }
}

/// Represents a paginated response.
struct InventoryPage<T>: Sendable where T: Sendable {
    let items: [T]
    let nextOffset: Int?
    let total: Int

    init(items: [T], nextOffset: Int?, total: Int) {
        self.items = items
        self.nextOffset = nextOffset
        self.total = total
    }
}
