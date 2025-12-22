import Foundation

public extension InventoryAppLogicValidators {
    
    /// Validates that a date's year is within a reasonable range (1950 - Current+1).
    public struct DateValidator: InventoryValidator {
        public typealias Input = Date
        
        public init() {}
        
        public func validate(_ input: Date) -> ValidationResult {
            let year = Calendar.current.component(.year, from: input)
            let currentYear = Calendar.current.component(.year, from: Date())
            
            if year > currentYear + 1 {
                return .failure(["Date is too far in the future: \(year)"])
            }
            
            if year < 1950 {
                return .warning(["Date is suspiciously early: \(year)"])
            }
            
            return .valid
        }
    }
}
