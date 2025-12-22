import Foundation

/// Defines the minimum or recommended system requirements for a product.
public struct InventorySystemRequirements: Codable, Sendable {
    
    // MARK: - Memory
    /// Minimum RAM required in bytes (e.g. 640_000 for 640KB).
    public var minMemory: Int64?
    
    /// Recommended RAM in bytes.
    public var recommendedMemory: Int64?
    
    // MARK: - CPU
    /// Processor family or specific model (e.g. "68030", "i486").
    public var cpuFamily: String?
    
    /// Minimum CPU speed in MHz.
    public var minCpuSpeedMHz: Double?
    
    // MARK: - Media / Peripherals
    /// Video requirement string (e.g. "VGA", "EGA", "MCGA").
    public var video: String?
    
    /// Audio requirement string (e.g. "Sound Blaster", "AdLib").
    public var audio: String?
    
    // MARK: - Operating System
    /// Operating System Name (e.g. "MS-DOS", "System 7", "Windows 95").
    public var osName: String?
    
    /// Minimum OS version string (e.g. "6.22").
    public var minOsVersion: String?
    
    public init(minMemory: Int64? = nil,
                recommendedMemory: Int64? = nil,
                cpuFamily: String? = nil,
                minCpuSpeedMHz: Double? = nil,
                video: String? = nil,
                audio: String? = nil,
                osName: String? = nil,
                minOsVersion: String? = nil) {
        self.minMemory = minMemory
        self.recommendedMemory = recommendedMemory
        self.cpuFamily = cpuFamily
        self.minCpuSpeedMHz = minCpuSpeedMHz
        self.video = video
        self.audio = audio
        self.osName = osName
        self.minOsVersion = minOsVersion
    }
}
