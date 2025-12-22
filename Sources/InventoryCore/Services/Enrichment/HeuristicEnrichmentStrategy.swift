import Foundation

/// A Tier 3 strategy that infers requirements based on the release year and platform.
public struct HeuristicEnrichmentStrategy: SystemRequirementsEnrichmentStrategy {
    
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
            return InventorySystemRequirements(
                minMemory: 48 * 1024, // 48KB
                recommendedMemory: 48 * 1024,
                cpuFamily: "6502",
                minCpuSpeedMHz: 1.0,
                video: "Composite",
                osName: "Apple DOS"
            )
        } else if year < 1987 {
            // Apple IIe / IIc era
            return InventorySystemRequirements(
                minMemory: 64 * 1024, // 64KB
                recommendedMemory: 128 * 1024,
                cpuFamily: "65C02",
                minCpuSpeedMHz: 1.0,
                video: "Double High Res",
                osName: "ProDOS"
            )
        } else {
            // IIGS era (late 80s)
            return InventorySystemRequirements(
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
