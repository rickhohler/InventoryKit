import Foundation
import InventoryTypes

/// Protocol for tag registry that enables code execution when tags are encountered.
///
/// `InventoryTagRegistry` enables domain-specific tag resolution through code execution handlers.
/// Clients can register custom tags that execute code when encountered, enabling powerful
/// tag-based processing workflows (e.g., RetroboxFS mapping tags to disk image types).
///
/// ## Key Features
///
/// - **Domain Organization**: Tags are organized by domain, preventing conflicts
/// - **Code Execution**: Attach handlers that execute when tags are encountered
/// - **Thread Safety**: All operations are safe for concurrent access
///
/// ## Usage Example
///
/// ```swift
/// let registry: InventoryTagRegistry = DefaultTagRegistry()
///
/// // Register a tag with code execution handler
/// try await registry.register(tag: "dsk", domain: "retroboxfs") { tag in
///     return "AppleDiskImage" // Returns type identifier
/// }
///
/// // Execute handler when tag is encountered
/// if let result = try await registry.execute(tag: "dsk", domain: "retroboxfs") {
///     print("Resolved type: \(result)") // "AppleDiskImage"
/// }
/// ```
///
/// - SeeAlso: ``DefaultTagRegistry`` for default implementation
/// - SeeAlso: ``InventoryService`` for service integration
/// - SeeAlso: ``InventoryAsset`` for asset tags
public protocol InventoryTagRegistry: Sendable {
    /// Register a tag for a domain with optional code execution handler
    ///
    /// - Parameters:
    ///   - tag: The tag to register (e.g., "dsk", "woz", "a2r")
    ///   - domain: The domain identifier (e.g., "retroboxfs")
    ///   - handler: Optional code execution handler (executes when tag is encountered).
    ///              Handler receives the tag as input and returns a domain-specific result (e.g., type identifier).
    ///              If nil, tag is registered without code execution.
    /// - Throws: Error if registration fails
    func register(tag: String, domain: String, handler: (@Sendable (String) async throws -> String)?) async throws
    
    /// Check if a tag is registered for a domain
    ///
    /// - Parameters:
    ///   - tag: The tag to check
    ///   - domain: The domain identifier
    /// - Returns: True if tag is registered for this domain
    /// - Throws: Error if check fails
    func isRegistered(tag: String, domain: String) async throws -> Bool
    
    /// Execute code for a tag (triggers registered handler)
    ///
    /// - Parameters:
    ///   - tag: The tag to execute code for
    ///   - domain: The domain identifier
    /// - Returns: Result of code execution (handler return value), or nil if no handler registered
    /// - Throws: Error if execution fails or handler throws
    func execute(tag: String, domain: String) async throws -> String?
    
    /// Get all tags for a domain
    ///
    /// - Parameter domain: The domain identifier
    /// - Returns: Set of tags registered for this domain
    /// - Throws: Error if query fails
    func tags(for domain: String) async throws -> Set<String>
    
    /// Resolve tag to domain
    ///
    /// - Parameter tag: The tag to resolve
    /// - Returns: Domain identifier if tag is registered, nil otherwise
    /// - Throws: Error if resolution fails
    func domain(for tag: String) async throws -> String?
}

