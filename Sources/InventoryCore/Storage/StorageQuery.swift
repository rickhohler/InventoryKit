import Foundation

/// Abstract representation of a query.
public struct StorageQuery: Sendable {
    public let filter: StorageFilter?
    public let sort: [StorageSortDescriptor]
    public let limit: Int?
    
    public init(filter: StorageFilter? = nil, sort: [StorageSortDescriptor] = [], limit: Int? = nil) {
        self.filter = filter
        self.sort = sort
        self.limit = limit
    }
}

/// A simplified, Sendable filter specification.
/// recursive enum to support AND/OR.
public indirect enum StorageFilter: Sendable {
    case all
    case id(UUID)
    case field(key: String, op: Operator, value: String)
    case and([StorageFilter])
    case or([StorageFilter])
    
    public enum Operator: String, Sendable {
        case equals = "=="
        case contains = "CONTAINS"
        case greaterThan = ">"
        case lessThan = "<"
    }
}

public struct StorageSortDescriptor: Sendable {
    public let key: String
    public let ascending: Bool
    
    public init(key: String, ascending: Bool = true) {
        self.key = key
        self.ascending = ascending
    }
}
