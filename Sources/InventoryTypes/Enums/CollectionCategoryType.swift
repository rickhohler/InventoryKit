import Foundation

/// Describes the intent or mechanism of the list grouping.
public enum CollectionCategoryType: String, Codable, Sendable {
    /// A statically defined list by an authority (e.g. "Best RPGs of 1990").
    case curatedSet = "curated_set"
    
    /// An arbitrary, user-ordered list (e.g. "To Play Next").
    case playlist
    
    /// A sequential grouping of related creative works (e.g. "Ultima I, II, III...").
    case series
    
    /// A dynamic collection defined by a query/predicate.
    case smartRule = "smart_rule"
    
    case software
    
    case hardware
    
    case unknown
}
