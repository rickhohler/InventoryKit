import Foundation

extension InventoryCatalog {
    func paginate<T>(items: [T], request: InventoryPageRequest) -> InventoryPage<T> where T: Sendable {
        let total = items.count
        let start = min(request.offset, total)
        let end = min(start + request.limit, total)
        let slice = Array(items[start..<end])
        let nextOffset = end < total ? end : nil
        return InventoryPage(items: slice, nextOffset: nextOffset, total: total)
    }
}
