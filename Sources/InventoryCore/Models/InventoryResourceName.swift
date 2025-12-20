import Foundation

/// A universal identifier for any resource in the Inventory ecosystem.
/// Format: `inventory:partition:service:namespace:type:id`
public struct InventoryResourceName: Codable, Hashable, Sendable, CustomStringConvertible {
    
    // MARK: - Components
    
    /// The scheme (always "inventory").
    public static let scheme = "inventory"
    
    /// The partition (scope) of the resource.
    public let partition: Partition
    
    /// The service (domain logic) responsible for the resource.
    public let service: Service
    
    /// The namespace (owner) of the resource.
    /// - "global": Shared catalog resources.
    /// - UUID: Specific user or vendor ID.
    public let namespace: String
    
    /// The specific type of the resource (optional/contextual).
    public let type: String
    
    /// The unique identifier for the resource.
    public let id: String
    
    // MARK: - Enums
    
    public enum Partition: String, Codable, Sendable {
        /// Public, shared catalog data.
        case `public`
        /// Private, user-specific data.
        case `private`
    }
    
    public enum Service: String, Codable, Sendable {
        case product
        case asset
        case collection
        case resource
        case bundle
        case delta
    }
    
    // MARK: - Initialization
    
    public init(partition: Partition, service: Service, namespace: String, type: String, id: String) {
        self.partition = partition
        self.service = service
        self.namespace = namespace
        self.type = type
        self.id = id
    }
    
    // MARK: - String Parsing/Serialization
    
    /// Parses a string into an IRN.
    /// Expected format: `inventory:partition:service:namespace:type:id`
    public init?(_ string: String) {
        let components = string.split(separator: ":", omittingEmptySubsequences: false)
        guard components.count >= 6,
              components[0] == Self.scheme,
              let partition = Partition(rawValue: String(components[1])),
              let service = Service(rawValue: String(components[2]))
        else {
            return nil
        }
        
        self.partition = partition
        self.service = service
        self.namespace = String(components[3])
        self.type = String(components[4])
        self.id = components[5...].joined(separator: ":") // Allow ID to contain colons? strictly no, but defensively join
    }
    
    public var description: String {
        return "\(Self.scheme):\(partition.rawValue):\(service.rawValue):\(namespace):\(type):\(id)"
    }
}
