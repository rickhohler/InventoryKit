import Foundation

/// A strategy that infers system requirements specifically for the Apple II platform based on release year.
public struct AppleIIEnrichmentStrategy: SystemRequirementsEnrichmentStrategy {
    
    public init() {}
    
    public func enrich(product: any InventoryProduct) -> InventorySystemRequirements? {
        guard let date = product.releaseDate ?? product.productionDate else {
            return nil
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        
        // Simple heuristics for Apple II platform (default context)
        // Adjust logic if platform is explicitly something else
        
        if year < 1983 {
            // Predominantly Apple II+ era
            return EnrichmentSystemRequirements(
                minMemory: 48 * 1024, // 48KB
                recommendedMemory: 48 * 1024,
                cpuFamily: "6502",
                minCpuSpeedMHz: 1.0,
                video: "Composite",
                osName: "Apple DOS"
            )
        } else if year < 1987 {
            // Apple IIe / IIc era
            return EnrichmentSystemRequirements(
                minMemory: 64 * 1024, // 64KB
                recommendedMemory: 128 * 1024,
                cpuFamily: "65C02",
                minCpuSpeedMHz: 1.0,
                video: "Double High Res",
                osName: "ProDOS"
            )
        } else {
            // IIGS era (late 80s)
            return EnrichmentSystemRequirements(
                minMemory: 256 * 1024, // 256KB
                recommendedMemory: 512 * 1024,
                cpuFamily: "65816",
                minCpuSpeedMHz: 2.8,
                video: "Super High Res",
                osName: "GS/OS"
            )
        }
    }
}

private struct EnrichmentSystemRequirements: InventorySystemRequirements, Codable, Sendable {
    var minMemory: Int64?
    var recommendedMemory: Int64?
    var cpuFamily: String?
    var minCpuSpeedMHz: Double?
    var video: String?
    var audio: String?
    var osName: String?
    var minOsVersion: String?
}
