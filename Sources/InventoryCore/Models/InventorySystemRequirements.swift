import Foundation

/// Defines the minimum or recommended system requirements for a product.
/// Defines the minimum or recommended system requirements for a product.
public protocol InventorySystemRequirements: Codable, Sendable {
    /// Minimum RAM required in bytes (e.g. 640_000 for 640KB).
    var minMemory: Int64? { get set }
    
    /// Recommended RAM in bytes.
    var recommendedMemory: Int64? { get set }
    
    /// Processor family or specific model (e.g. "68030", "i486").
    var cpuFamily: String? { get set }
    
    /// Minimum CPU speed in MHz.
    var minCpuSpeedMHz: Double? { get set }
    
    /// Video requirement string (e.g. "VGA", "EGA", "MCGA").
    var video: String? { get set }
    
    /// Audio requirement string (e.g. "Sound Blaster", "AdLib").
    var audio: String? { get set }
    
    /// Operating System Name (e.g. "MS-DOS", "System 7", "Windows 95").
    var osName: String? { get set }
    
    /// Minimum OS version string (e.g. "6.22").
    var minOsVersion: String? { get set }
}
