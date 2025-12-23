import Foundation

/// Standardized, namespaced tags for Inventory Items.
/// All tags are lowercased and use a `namespace:value` format where applicable.
public enum TagType {
    
    /// Unified protocol for all tag types
    public protocol TagType: RawRepresentable, CaseIterable, Sendable where RawValue == String {
        var localizedLabel: String { get }
    }
    
    /// Returns all known tag types as a unified collection.
    /// Useful for TagKit integration and UI pickers.
    public static var allTags: [any TagType] {
        var tags: [any TagType] = []
        tags.append(contentsOf: Condition.allCases)
        tags.append(contentsOf: Format.allCases)
        tags.append(contentsOf: Content.allCases)
        tags.append(contentsOf: DigitalState.allCases)
        tags.append(contentsOf: Manufacturer.allCases)
        tags.append(contentsOf: Region.allCases)
        tags.append(contentsOf: Acquisition.allCases)
        tags.append(contentsOf: Interface.allCases)
        tags.append(contentsOf: Material.allCases)
        tags.append(contentsOf: MediaFormatType.allCases)
        return tags
    }
    
    public enum Condition: String, TagType, Codable {
        // Condition Grades (Collector/Industry Standards)
        case new = "condition:new"                 // Brand new, unused
        case sealed = "condition:sealed"           // Factory sealed (WATA/VGA relevance)
        case openBox = "condition:open_box"        // Opened but never used
        case mint = "condition:mint"               // Perfect/Like New (CIB usually)
        case nearMint = "condition:near_mint"      // Near Mint: Minimal wear, almost perfect
        case excellent = "condition:excellent"     // Excellent: Very minor signs of wear
        case veryGood = "condition:very_good"      // Very Good: Visible defects but well cared for
        case good = "condition:good"               // G - Moderate wear
        case fair = "condition:fair"               // Acceptable, cosmetic issues
        case poor = "condition:poor"               // Heavy wear, damage
        case forParts = "condition:for_parts"      // Non-functional/Parts only
        
        // Functional State
        case working = "condition:working"
        case notWorking = "condition:not_working"
        case untested = "condition:untested"
        
        // Specific Attributes
        case cib = "condition:cib"                 // Complete In Box
        case loose = "condition:loose"             // Cartridge/Unit only
        case boxed = "condition:boxed"             // Has box but maybe not CIB
        case recapped = "condition:recapped"       // Maintenance performed
        case modded = "condition:modded"           // Modified hardware
        case yellowed = "condition:yellowed"       // UV damage (Retrobright candidate)
        case damaged = "condition:damaged"         // Physical damage (cracks, etc)
        
        // Museum/Conservation Terms
        case stable = "condition:stable"           // Structurally sound
        case fragile = "condition:fragile"         // Needs special handling
        case deteriorating = "condition:deteriorating" // Active degradation (batteries, caps)
        case corrosion = "condition:corrosion"     // Rust, battery leak
        case discoloration = "condition:discoloration" // Sun fading, yellowing
        case incomplete = "condition:incomplete"   // Missing parts
        
        public var localizedLabel: String {
            switch self {
            case .new: return InventoryLocalizedString("condition.new", value: "New", comment: "Condition: New")
            case .sealed: return InventoryLocalizedString("condition.sealed", value: "Factory Sealed", comment: "Condition: Factory Sealed")
            case .openBox: return InventoryLocalizedString("condition.openBox", value: "Open Box", comment: "Condition: Open Box")
            case .mint: return InventoryLocalizedString("condition.mint", value: "Mint", comment: "Condition: Mint")
            case .nearMint: return InventoryLocalizedString("condition.nearMint", value: "Near Mint", comment: "Condition: Near Mint")
            case .excellent: return InventoryLocalizedString("condition.excellent", value: "Excellent", comment: "Condition: Excellent")
            case .veryGood: return InventoryLocalizedString("condition.veryGood", value: "Very Good", comment: "Condition: Very Good")
            case .good: return InventoryLocalizedString("condition.good", value: "Good", comment: "Condition: Good")
            case .fair: return InventoryLocalizedString("condition.fair", value: "Fair", comment: "Condition: Fair")
            case .poor: return InventoryLocalizedString("condition.poor", value: "Poor", comment: "Condition: Poor")
            case .forParts: return InventoryLocalizedString("condition.forParts", value: "For Parts / Not Working", comment: "Condition: For Parts")
            case .working: return InventoryLocalizedString("condition.working", value: "Working", comment: "Condition: Working")
            case .notWorking: return InventoryLocalizedString("condition.notWorking", value: "Not Working", comment: "Condition: Not Working")
            case .untested: return InventoryLocalizedString("condition.untested", value: "Untested", comment: "Condition: Untested")
            case .cib: return InventoryLocalizedString("condition.cib", value: "Complete In Box", comment: "Condition: CIB")
            case .loose: return InventoryLocalizedString("condition.loose", value: "Loose", comment: "Condition: Loose")
            case .boxed: return InventoryLocalizedString("condition.boxed", value: "Boxed", comment: "Condition: Boxed")
            case .recapped: return InventoryLocalizedString("condition.recapped", value: "Recapped", comment: "Condition: Recapped")
            case .modded: return InventoryLocalizedString("condition.modded", value: "Modded", comment: "Condition: Modded")
            case .yellowed: return InventoryLocalizedString("condition.yellowed", value: "Yellowed / Discolored", comment: "Condition: Yellowed")
            case .damaged: return InventoryLocalizedString("condition.damaged", value: "Damaged", comment: "Condition: Damaged")
            case .stable: return InventoryLocalizedString("condition.stable", value: "Stable", comment: "Condition: Stable")
            case .fragile: return InventoryLocalizedString("condition.fragile", value: "Fragile", comment: "Condition: Fragile")
            case .deteriorating: return InventoryLocalizedString("condition.deteriorating", value: "Deteriorating", comment: "Condition: Deteriorating")
            case .corrosion: return InventoryLocalizedString("condition.corrosion", value: "Corroded", comment: "Condition: Corroded")
            case .discoloration: return InventoryLocalizedString("condition.discoloration", value: "Discolored", comment: "Condition: Discolored")
            case .incomplete: return InventoryLocalizedString("condition.incomplete", value: "Incomplete", comment: "Condition: Incomplete")
            }
        }
    }
    
    public enum Format: String, TagType, Codable {
        case physical = "format:physical"
        case digital = "format:digital"
        case executable = "format:executable"
        case diskImage = "format:disk_image"
        case fluxImage = "format:flux_image"
        case rom = "format:rom"
        case cassette = "format:cassette"
        case archive = "format:archive"
        
        public var localizedLabel: String {
            switch self {
            case .physical: return InventoryLocalizedString("format.physical", value: "Physical Item", comment: "Format: Physical")
            case .digital: return InventoryLocalizedString("format.digital", value: "Digital File", comment: "Format: Digital")
            case .executable: return InventoryLocalizedString("format.executable", value: "Executable", comment: "Format: Executable")
            case .diskImage: return InventoryLocalizedString("format.diskImage", value: "Disk Image", comment: "Format: Disk Image")
            case .fluxImage: return InventoryLocalizedString("format.fluxImage", value: "Flux Image", comment: "Format: Flux Image")
            case .rom: return InventoryLocalizedString("format.rom", value: "ROM Image", comment: "Format: ROM")
            case .cassette: return InventoryLocalizedString("format.cassette", value: "Cassette Image", comment: "Format: Cassette")
            case .archive: return InventoryLocalizedString("format.archive", value: "Archive / Zip", comment: "Format: Archive")
            }
        }
    }
    
    public enum Content: String, TagType, Codable {
        case manual = "content:manual"
        case box = "content:box"
        case media = "content:media"
        case map = "content:map"
        case registrationCard = "content:reg_card"
        case cables = "content:cables"
        case powerSupply = "content:psu"
        
        public var localizedLabel: String {
            switch self {
            case .manual: return InventoryLocalizedString("content.manual", value: "Manual / Documentation", comment: "Content: Manual")
            case .box: return InventoryLocalizedString("content.box", value: "Box / Packaging", comment: "Content: Box")
            case .media: return InventoryLocalizedString("content.media", value: "Game Media", comment: "Content: Media")
            case .map: return InventoryLocalizedString("content.map", value: "Map", comment: "Content: Map")
            case .registrationCard: return InventoryLocalizedString("content.registrationCard", value: "Registration Card", comment: "Content: Reg Card")
            case .cables: return InventoryLocalizedString("content.cables", value: "Cables", comment: "Content: Cables")
            case .powerSupply: return InventoryLocalizedString("content.powerSupply", value: "Power Supply", comment: "Content: PSU")
            }
        }
    }
    
    public enum DigitalState: String, TagType, Codable {
        case cracked = "state:cracked"
        case trainer = "state:trainer"
        case verifiedClean = "state:verified_clean"
        case originalDump = "state:original_dump"
        
        public var localizedLabel: String {
            switch self {
            case .cracked: return InventoryLocalizedString("state.cracked", value: "Cracked", comment: "State: Cracked")
            case .trainer: return InventoryLocalizedString("state.trainer", value: "Trainer / Cheat", comment: "State: Trainer")
            case .verifiedClean: return InventoryLocalizedString("state.verifiedClean", value: "Verified Clean", comment: "State: Verified Clean")
            case .originalDump: return InventoryLocalizedString("state.originalDump", value: "Original Dump", comment: "State: Original Dump")
            }
        }
    }
    
    public enum Manufacturer: String, TagType, Codable {
        case publisher = "type:publisher"
        case developer = "type:developer"
        case hardware = "type:hardware_mfg"
        case indie = "status:indie"
        case active = "status:active"
        case defunct = "status:defunct"
        case acquired = "status:acquired"
        case merged = "status:merged"
        
        public var localizedLabel: String {
            switch self {
            case .publisher: return InventoryLocalizedString("mfg.publisher", value: "Software Publisher", comment: "Mfg: Publisher")
            case .developer: return InventoryLocalizedString("mfg.developer", value: "Software Developer", comment: "Mfg: Developer")
            case .hardware: return InventoryLocalizedString("mfg.hardware", value: "Hardware Manufacturer", comment: "Mfg: Hardware")
            case .indie: return InventoryLocalizedString("mfg.indie", value: "Indie Developer", comment: "Mfg: Indie")
            case .active: return InventoryLocalizedString("mfg.active", value: "Active", comment: "Mfg: Active")
            case .defunct: return InventoryLocalizedString("mfg.defunct", value: "Defunct", comment: "Mfg: Defunct")
            case .acquired: return InventoryLocalizedString("mfg.acquired", value: "Acquired", comment: "Mfg: Acquired")
            case .merged: return InventoryLocalizedString("mfg.merged", value: "Merged", comment: "Mfg: Merged")
            }
        }
    }
    
    public enum Region: String, TagType, Codable {
        case ntsc = "region:ntsc"
        case pal = "region:pal"
        case usa = "region:usa"
        case eur = "region:eur"
        case jpn = "region:jpn"
        
        public var localizedLabel: String {
            switch self {
            case .ntsc: return InventoryLocalizedString("region.ntsc", value: "NTSC", comment: "Region: NTSC")
            case .pal: return InventoryLocalizedString("region.pal", value: "PAL", comment: "Region: PAL")
            case .usa: return InventoryLocalizedString("region.usa", value: "North America (USA)", comment: "Region: USA")
            case .eur: return InventoryLocalizedString("region.eur", value: "Europe", comment: "Region: Europe")
            case .jpn: return InventoryLocalizedString("region.jpn", value: "Japan", comment: "Region: Japan")
            }
        }
    }

    public enum Acquisition: String, TagType, Codable {
        case purchase = "acq:purchase"
        case gift = "acq:gift"
        case donation = "acq:donation"
        case bequest = "acq:bequest"
        case found = "acq:found"
        case trade = "acq:trade"
        case unknown = "acq:unknown"
        
        public var localizedLabel: String {
            switch self {
            case .purchase: return InventoryLocalizedString("acq.purchase", value: "Purchased", comment: "Acq: Purchase")
            case .gift: return InventoryLocalizedString("acq.gift", value: "Gifted", comment: "Acq: Gift")
            case .donation: return InventoryLocalizedString("acq.donation", value: "Donated", comment: "Acq: Donation")
            case .bequest: return InventoryLocalizedString("acq.bequest", value: "Bequest", comment: "Acq: Bequest")
            case .found: return InventoryLocalizedString("acq.found", value: "Found", comment: "Acq: Found")
            case .trade: return InventoryLocalizedString("acq.trade", value: "Traded", comment: "Acq: Trade")
            case .unknown: return InventoryLocalizedString("acq.unknown", value: "Unknown", comment: "Acq: Unknown")
            }
        }
    }



    // MARK: - New Domains
    
    public enum Interface: String, TagType, Codable {
        case usb = "interface:usb"
        case serial = "interface:serial"
        case parallel = "interface:parallel"
        case ps2 = "interface:ps2"
        case adb = "interface:adb" // Apple Desktop Bus
        case scsi = "interface:scsi"
        case ide = "interface:ide"
        case midi = "interface:midi"
        case gameport = "interface:gameport"
        case proprietary = "interface:proprietary"
        
        public var localizedLabel: String {
            switch self {
            case .usb: return InventoryLocalizedString("interface.usb", value: "USB", comment: "Interface: USB")
            case .serial: return InventoryLocalizedString("interface.serial", value: "Serial", comment: "Interface: Serial")
            case .parallel: return InventoryLocalizedString("interface.parallel", value: "Parallel", comment: "Interface: Parallel")
            case .ps2: return InventoryLocalizedString("interface.ps2", value: "PS/2", comment: "Interface: PS/2")
            case .adb: return InventoryLocalizedString("interface.adb", value: "ADB (Apple Desktop Bus)", comment: "Interface: ADB")
            case .scsi: return InventoryLocalizedString("interface.scsi", value: "SCSI", comment: "Interface: SCSI")
            case .ide: return InventoryLocalizedString("interface.ide", value: "IDE / PATA", comment: "Interface: IDE")
            case .midi: return InventoryLocalizedString("interface.midi", value: "MIDI", comment: "Interface: MIDI")
            case .gameport: return InventoryLocalizedString("interface.gameport", value: "Gameport", comment: "Interface: Gameport")
            case .proprietary: return InventoryLocalizedString("interface.proprietary", value: "Proprietary", comment: "Interface: Proprietary")
            }
        }
    }
    
    public enum Material: String, TagType, Codable {
        case plastic = "material:plastic"
        case metal = "material:metal"
        case wood = "material:wood"
        case paper = "material:paper"
        case cardboard = "material:cardboard"
        
        public var localizedLabel: String {
            switch self {
            case .plastic: return InventoryLocalizedString("material.plastic", value: "Plastic", comment: "Material: Plastic")
            case .metal: return InventoryLocalizedString("material.metal", value: "Metal", comment: "Material: Metal")
            case .wood: return InventoryLocalizedString("material.wood", value: "Wood", comment: "Material: Wood")
            case .paper: return InventoryLocalizedString("material.paper", value: "Paper", comment: "Material: Paper")
            case .cardboard: return InventoryLocalizedString("material.cardboard", value: "Cardboard", comment: "Material: Cardboard")
            }
        }
    }
    
    public enum MediaFormatType: String, TagType, Codable {
        case vhs = "media:vhs"
        case dvd = "media:dvd"
        case cd = "media:cd"
        case vinyl = "media:vinyl"
        case cassetteAudio = "media:cassette_audio"
        case laserdisc = "media:laserdisc"
        
        public var localizedLabel: String {
            switch self {
            case .vhs: return InventoryLocalizedString("media.vhs", value: "VHS", comment: "Media: VHS")
            case .dvd: return InventoryLocalizedString("media.dvd", value: "DVD", comment: "Media: DVD")
            case .cd: return InventoryLocalizedString("media.cd", value: "CD / CD-ROM", comment: "Media: CD")
            case .vinyl: return InventoryLocalizedString("media.vinyl", value: "Vinyl Record", comment: "Media: Vinyl")
            case .cassetteAudio: return InventoryLocalizedString("media.cassetteAudio", value: "Audio Cassette", comment: "Media: Cassette")
            case .laserdisc: return InventoryLocalizedString("media.laserdisc", value: "LaserDisc", comment: "Media: LaserDisc")
            }
        }
    }
}
