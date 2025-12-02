import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension InventoryCatalog {
    func paginate<T: Sendable>(items: [T], request: InventoryPageRequest) -> InventoryPage<T> {
        let total = items.count
        let start = min(request.offset, total)
        let end = min(start + request.limit, total)
        let slice = Array(items[start..<end])
        let nextOffset = end < total ? end : nil
        return InventoryPage(items: slice, nextOffset: nextOffset, total: total)
    }
}
