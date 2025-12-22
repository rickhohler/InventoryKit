import Foundation

public extension InventoryFormattingStrategies {
    
    /// Strict cleaning strategy for keys/slugs.
    /// Removes non-alphanumeric characters (except . - _ ( ) [ ]).
    struct StrictKeyStrategy: FormattingStrategy {
        
        public init() {}
        
        public func format(_ value: String) -> String {
            let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: ".-_()[] "))
            return value.components(separatedBy: allowed.inverted).joined()
        }
    }
}
