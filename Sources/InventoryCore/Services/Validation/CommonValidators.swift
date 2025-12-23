import Foundation
import InventoryTypes

/// Common validators for primitive types and logic.
public enum InventoryAppLogicValidators {
    
    /// Validates that a string URL is valid and has a scheme.
    public struct URLStringValidator: InventoryValidator {
        public typealias Input = String
        
        public init() {}
        
        public func validate(_ input: String) -> ValidationResult {
            guard let url = URL(string: input), let scheme = url.scheme else {
                return .failure(["Invalid URL format: \(input)"])
            }
            
            // Check for valid scheme
            let validSchemes = ["http", "https", "file", "ftp"]
            if !validSchemes.contains(scheme.lowercased()) {
                 return .failure(["Invalid URL scheme: \(scheme)"])
            }
            
            // For web URLs, host is required
            if ["http", "https", "ftp"].contains(scheme.lowercased()) {
                if url.host == nil || url.host!.isEmpty {
                    return .failure(["URL is missing host: \(input)"])
                }
            }
            
            return .valid
        }
    }
    
    /// Validates numeric ranges (e.g. Memory > 0).
    public struct PositiveNumberValidator: InventoryValidator {
        public typealias Input = Int64
        
        public init() {}
        
        public func validate(_ input: Int64) -> ValidationResult {
            if input < 0 {
                return .failure(["Value must be positive: \(input)"])
            }
            return .valid
        }
    }
}
