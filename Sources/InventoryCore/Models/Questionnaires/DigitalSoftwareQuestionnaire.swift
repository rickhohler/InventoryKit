import Foundation

/// Questionnaire for Digital Software (Disk Images, ROMs, Archives).
public struct DigitalSoftwareQuestionnaire: InventoryQuestionnaire {
    public let targetClassifier: InventoryItemClassifier
    
    // MARK: - Format & Type
    public enum ImageFormat: String, Codable, Sendable, CaseIterable {
        case diskImage = "Disk Image" // dsk, d64, adf
        case fluxImage = "Flux Image" // woz, a2r, ipf
        case rom = "ROM" // bin, rom
        case cassette = "Cassette" // tap, t64, cas
        case archive = "Archive" // zip, lha, sit
        case executable = "Executable" // exe, com, prg
    }
    public var format: ImageFormat
    
    // MARK: - Integrity/State
    public var isCracked: Bool
    public var hasTrainer: Bool
    public var isVerifiedClean: Bool // Verified against TOSEC/No-Intro
    
    // MARK: - Region
    public var region: String? // NTSC, PAL, USA, EUR, JPN
    
    // MARK: - Provenance related to Digital
    public var isOriginalDump: Bool // Self-dumped from own media
    
    public init(
        classifier: InventoryItemClassifier = .software,
        format: ImageFormat = .diskImage,
        isCracked: Bool = false,
        hasTrainer: Bool = false,
        isVerifiedClean: Bool = false,
        region: String? = nil,
        isOriginalDump: Bool = false
    ) {
        self.targetClassifier = classifier
        self.format = format
        self.isCracked = isCracked
        self.hasTrainer = hasTrainer
        self.isVerifiedClean = isVerifiedClean
        self.region = region
        self.isOriginalDump = isOriginalDump
    }
    
    public func generateTags() -> [String] {
        var tags: [String] = []
        
        switch format {
        case .diskImage: tags.append(InventoryTag.Format.diskImage.rawValue)
        case .fluxImage: tags.append(InventoryTag.Format.fluxImage.rawValue)
        case .rom: tags.append(InventoryTag.Format.rom.rawValue)
        case .cassette: tags.append(InventoryTag.Format.cassette.rawValue)
        case .archive: tags.append(InventoryTag.Format.archive.rawValue)
        // Others map to defaults or we add new tags
        case .executable:  tags.append(InventoryTag.Format.executable.rawValue)
        @unknown default: break
        }
        
        if isCracked { tags.append(InventoryTag.DigitalState.cracked.rawValue) }
        if hasTrainer { tags.append(InventoryTag.DigitalState.trainer.rawValue) }
        if isVerifiedClean { tags.append(InventoryTag.DigitalState.verifiedClean.rawValue) }
        if isOriginalDump { tags.append(InventoryTag.DigitalState.originalDump.rawValue) }
        
        if let reg = region {
            // Map common regions if possible, or just use as is but lowercased/namespaced if strictly enforcing
            // For now, let's prefix
            tags.append("region:\(reg.lowercased())")
        }
        
        return tags
    }
    
    public func generateAttributes() -> [String : String] {
        var attrs: [String: String] = [:]
        
        attrs["format_type"] = format.rawValue
        attrs["is_cracked"] = String(isCracked)
        attrs["has_trainer"] = String(hasTrainer)
        attrs["is_clean"] = String(isVerifiedClean)
        attrs["is_original_dump"] = String(isOriginalDump)
        
        if let reg = region {
            attrs["region"] = reg
        }
        
        return attrs
    }
    
    public var localizedQuestions: [String: String] {
        return [
            "format": NSLocalizedString("question.digitalFormat", bundle: .inventoryKit, value: "What is the file format?", comment: "Question: Format"),
            "isCracked": NSLocalizedString("question.isCracked", bundle: .inventoryKit, value: "Is this version cracked?", comment: "Question: Cracked"),
            "hasTrainer": NSLocalizedString("question.hasTrainer", bundle: .inventoryKit, value: "Does it include a trainer/cheat?", comment: "Question: Trainer"),
            "isVerifiedClean": NSLocalizedString("question.isVerifiedClean", bundle: .inventoryKit, value: "Is is verified against a database (e.g. TOSEC)?", comment: "Question: Verified Clean"),
            "region": NSLocalizedString("question.region", bundle: .inventoryKit, value: "What is the region (NTSC/PAL)?", comment: "Question: Region"),
            "isOriginalDump": NSLocalizedString("question.isOriginalDump", bundle: .inventoryKit, value: "Did you dump this yourself from original media?", comment: "Question: Original Dump")
        ]
    }
}
