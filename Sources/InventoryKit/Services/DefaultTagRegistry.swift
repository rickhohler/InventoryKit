import Foundation
import InventoryCore

/// Default implementation of `InventoryTagRegistry` protocol
///
/// Provides thread-safe tag registration and code execution capabilities using Swift actors.
/// Tags are organized by domain, allowing multiple clients to register tags without conflicts.
///
/// ## Usage Example
/// ```swift
/// let registry = DefaultTagRegistry()
///
/// // Register a tag with code execution handler
/// try await registry.register(tag: "dsk", domain: "retroboxfs") { tag in
///     return "AppleDiskImage"
/// }
///
/// // Check if tag is registered
/// let isRegistered = try await registry.isRegistered(tag: "dsk", domain: "retroboxfs")
///
/// // Execute handler
/// if let result = try await registry.execute(tag: "dsk", domain: "retroboxfs") {
///     print("Resolved: \(result)")
/// }
/// ```
public actor DefaultTagRegistry: InventoryTagRegistry {
    /// Type alias for tag handler function
    public typealias TagHandler = @Sendable (String) async throws -> String
    
    /// Storage for tag handlers: domain -> tag -> handler
    private var handlers: [String: [String: TagHandler]] = [:]
    
    /// Storage for registered tags: domain -> Set<tag>
    private var registeredTags: [String: Set<String>] = [:]
    
    /// Storage for tag-to-domain mapping: tag -> domain
    private var tagToDomain: [String: String] = [:]
    
    public init() {}
    
    // MARK: - InventoryTagRegistry Implementation
    
    public func register(tag: String, domain: String, handler: TagHandler?) async throws {
        let normalizedTag = tag.lowercased()
        let normalizedDomain = domain.lowercased()
        
        // Initialize domain storage if needed
        if handlers[normalizedDomain] == nil {
            handlers[normalizedDomain] = [:]
            registeredTags[normalizedDomain] = []
        }
        
        // Store handler if provided
        if let handler = handler {
            handlers[normalizedDomain]?[normalizedTag] = handler
        }
        
        // Register tag
        registeredTags[normalizedDomain]?.insert(normalizedTag)
        tagToDomain[normalizedTag] = normalizedDomain
    }
    
    public func isRegistered(tag: String, domain: String) async throws -> Bool {
        let normalizedTag = tag.lowercased()
        let normalizedDomain = domain.lowercased()
        
        guard let domainTags = registeredTags[normalizedDomain] else {
            return false
        }
        
        return domainTags.contains(normalizedTag)
    }
    
    public func execute(tag: String, domain: String) async throws -> String? {
        let normalizedTag = tag.lowercased()
        let normalizedDomain = domain.lowercased()
        
        // Check if tag is registered for this domain
        guard try await isRegistered(tag: normalizedTag, domain: normalizedDomain) else {
            return nil
        }
        
        // Get handler if available
        guard let handler = handlers[normalizedDomain]?[normalizedTag] else {
            return nil
        }
        
        // Execute handler
        return try await handler(normalizedTag)
    }
    
    public func tags(for domain: String) async throws -> Set<String> {
        let normalizedDomain = domain.lowercased()
        return registeredTags[normalizedDomain] ?? []
    }
    
    public func domain(for tag: String) async throws -> String? {
        let normalizedTag = tag.lowercased()
        return tagToDomain[normalizedTag]
    }
}

