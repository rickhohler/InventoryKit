import Foundation

/// Represents copyright information for an asset.
///
/// `CopyrightInfoProtocol` stores structured copyright data including the full copyright text,
/// extracted year, holder, and license information.
public protocol CopyrightInfoProtocol: Sendable {
    /// Full copyright text (preserved exactly as found).
    var text: String? { get }
    
    /// Copyright year (extracted from text).
    var year: Int? { get }
    
    /// Copyright holder(s) (extracted from text).
    var holder: String? { get }
    
    /// License type (if applicable).
    var license: String? { get }
    
    /// Additional copyright metadata.
    var metadata: [String: String] { get }
}

