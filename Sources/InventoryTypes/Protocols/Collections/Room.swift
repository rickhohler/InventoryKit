import Foundation

/// Represents a specific room within a physical building.
public protocol Room: Space {
    /// The floor level (e.g., 1 for ground, -1 for basement).
    var level: Int { get set }
    
    /// The parent building.
    /// Note: In protocol, we might want this to be `any Building`.
    var building: any Building { get set }
}
