import Foundation
import InventoryTypes

public extension InventoryAppLogicValidators {
    
    /// Validates that a date's year is within a reasonable range: a failure after next year, a
    /// warning before `earliestPlausibleYear` (1950 by default).
    struct DateValidator: InventoryValidator {
        public typealias Input = Date

        /// Years before this one produce a warning.
        public let earliestPlausibleYear: Int
        
        public init(earliestPlausibleYear: Int = 1950) {
            self.earliestPlausibleYear = earliestPlausibleYear
        }
        
        public func validate(_ input: Date) -> ValidationResult {
            let year = Calendar.current.component(.year, from: input)
            let currentYear = Calendar.current.component(.year, from: Date())
            
            if year > currentYear + 1 {
                return .failure(["Date is too far in the future: \(year)"])
            }
            
            if year < earliestPlausibleYear {
                return .warning(["Date is suspiciously early: \(year)"])
            }
            
            return .valid
        }
    }
}
