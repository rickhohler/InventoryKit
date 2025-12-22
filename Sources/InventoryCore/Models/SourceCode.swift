import Foundation

/// Represents details about the source code availability for an item.
/// Represents details about the source code availability for an item.
public protocol InventorySourceCode: Codable, Sendable {
    /// The URL where the source code is hosted (e.g. GitHub, GitLab, SourceForge).
    var url: URL { get set }
    
    /// Notes regarding the source code (e.g. "incomplete", "requires patches").
    var notes: String? { get set }
    
    /// The date when the source code was made open/public, if known.
    var dateOpened: Date? { get }
    
    /// The license under which the source code is released (e.g. "MIT", "GPLv3").
    var license: String? { get }
}
