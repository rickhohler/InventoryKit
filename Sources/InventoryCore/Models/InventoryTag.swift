import Foundation

/// Standardized, namespaced tags for Inventory Items.
/// All tags are lowercased and use a `namespace:value` format where applicable.
public enum InventoryTag {
    
    public enum Condition: String, CaseIterable, Sendable, Codable {
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
            case .new: return NSLocalizedString("condition.new", bundle: .inventoryKit, value: "New", comment: "Condition: New")
            case .sealed: return NSLocalizedString("condition.sealed", bundle: .inventoryKit, value: "Factory Sealed", comment: "Condition: Factory Sealed")
            case .openBox: return NSLocalizedString("condition.openBox", bundle: .inventoryKit, value: "Open Box", comment: "Condition: Open Box")
            case .mint: return NSLocalizedString("condition.mint", bundle: .inventoryKit, value: "Mint", comment: "Condition: Mint")
            case .nearMint: return NSLocalizedString("condition.nearMint", bundle: .inventoryKit, value: "Near Mint", comment: "Condition: Near Mint")
            case .excellent: return NSLocalizedString("condition.excellent", bundle: .inventoryKit, value: "Excellent", comment: "Condition: Excellent")
            case .veryGood: return NSLocalizedString("condition.veryGood", bundle: .inventoryKit, value: "Very Good", comment: "Condition: Very Good")
            case .good: return NSLocalizedString("condition.good", bundle: .inventoryKit, value: "Good", comment: "Condition: Good")
            case .fair: return NSLocalizedString("condition.fair", bundle: .inventoryKit, value: "Fair", comment: "Condition: Fair")
            case .poor: return NSLocalizedString("condition.poor", bundle: .inventoryKit, value: "Poor", comment: "Condition: Poor")
            case .forParts: return NSLocalizedString("condition.forParts", bundle: .inventoryKit, value: "For Parts / Not Working", comment: "Condition: For Parts")
            case .working: return NSLocalizedString("condition.working", bundle: .inventoryKit, value: "Working", comment: "Condition: Working")
            case .notWorking: return NSLocalizedString("condition.notWorking", bundle: .inventoryKit, value: "Not Working", comment: "Condition: Not Working")
            case .untested: return NSLocalizedString("condition.untested", bundle: .inventoryKit, value: "Untested", comment: "Condition: Untested")
            case .cib: return NSLocalizedString("condition.cib", bundle: .inventoryKit, value: "Complete In Box", comment: "Condition: CIB")
            case .loose: return NSLocalizedString("condition.loose", bundle: .inventoryKit, value: "Loose", comment: "Condition: Loose")
            case .boxed: return NSLocalizedString("condition.boxed", bundle: .inventoryKit, value: "Boxed", comment: "Condition: Boxed")
            case .recapped: return NSLocalizedString("condition.recapped", bundle: .inventoryKit, value: "Recapped", comment: "Condition: Recapped")
            case .modded: return NSLocalizedString("condition.modded", bundle: .inventoryKit, value: "Modded", comment: "Condition: Modded")
            case .yellowed: return NSLocalizedString("condition.yellowed", bundle: .inventoryKit, value: "Yellowed / Discolored", comment: "Condition: Yellowed")
            case .damaged: return NSLocalizedString("condition.damaged", bundle: .inventoryKit, value: "Damaged", comment: "Condition: Damaged")
            case .stable: return NSLocalizedString("condition.stable", bundle: .inventoryKit, value: "Stable", comment: "Condition: Stable")
            case .fragile: return NSLocalizedString("condition.fragile", bundle: .inventoryKit, value: "Fragile", comment: "Condition: Fragile")
            case .deteriorating: return NSLocalizedString("condition.deteriorating", bundle: .inventoryKit, value: "Deteriorating", comment: "Condition: Deteriorating")
            case .corrosion: return NSLocalizedString("condition.corrosion", bundle: .inventoryKit, value: "Corroded", comment: "Condition: Corroded")
            case .discoloration: return NSLocalizedString("condition.discoloration", bundle: .inventoryKit, value: "Discolored", comment: "Condition: Discolored")
            case .incomplete: return NSLocalizedString("condition.incomplete", bundle: .inventoryKit, value: "Incomplete", comment: "Condition: Incomplete")
            }
        }
    }
    
    public enum Format: String, CaseIterable, Sendable, Codable {
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
            case .physical: return NSLocalizedString("format.physical", bundle: .inventoryKit, value: "Physical Item", comment: "Format: Physical")
            case .digital: return NSLocalizedString("format.digital", bundle: .inventoryKit, value: "Digital File", comment: "Format: Digital")
            case .executable: return NSLocalizedString("format.executable", bundle: .inventoryKit, value: "Executable", comment: "Format: Executable")
            case .diskImage: return NSLocalizedString("format.diskImage", bundle: .inventoryKit, value: "Disk Image", comment: "Format: Disk Image")
            case .fluxImage: return NSLocalizedString("format.fluxImage", bundle: .inventoryKit, value: "Flux Image", comment: "Format: Flux Image")
            case .rom: return NSLocalizedString("format.rom", bundle: .inventoryKit, value: "ROM Image", comment: "Format: ROM")
            case .cassette: return NSLocalizedString("format.cassette", bundle: .inventoryKit, value: "Cassette Image", comment: "Format: Cassette")
            case .archive: return NSLocalizedString("format.archive", bundle: .inventoryKit, value: "Archive / Zip", comment: "Format: Archive")
            }
        }
    }
    
    public enum Content: String, CaseIterable, Sendable, Codable {
        case manual = "content:manual"
        case box = "content:box"
        case media = "content:media"
        case map = "content:map"
        case registrationCard = "content:reg_card"
        case cables = "content:cables"
        case powerSupply = "content:psu"
        
        public var localizedLabel: String {
            switch self {
            case .manual: return NSLocalizedString("content.manual", bundle: .inventoryKit, value: "Manual / Documentation", comment: "Content: Manual")
            case .box: return NSLocalizedString("content.box", bundle: .inventoryKit, value: "Box / Packaging", comment: "Content: Box")
            case .media: return NSLocalizedString("content.media", bundle: .inventoryKit, value: "Game Media", comment: "Content: Media")
            case .map: return NSLocalizedString("content.map", bundle: .inventoryKit, value: "Map", comment: "Content: Map")
            case .registrationCard: return NSLocalizedString("content.registrationCard", bundle: .inventoryKit, value: "Registration Card", comment: "Content: Reg Card")
            case .cables: return NSLocalizedString("content.cables", bundle: .inventoryKit, value: "Cables", comment: "Content: Cables")
            case .powerSupply: return NSLocalizedString("content.powerSupply", bundle: .inventoryKit, value: "Power Supply", comment: "Content: PSU")
            }
        }
    }
    
    public enum DigitalState: String, CaseIterable, Sendable, Codable {
        case cracked = "state:cracked"
        case trainer = "state:trainer"
        case verifiedClean = "state:verified_clean"
        case originalDump = "state:original_dump"
        
        public var localizedLabel: String {
            switch self {
            case .cracked: return NSLocalizedString("state.cracked", bundle: .inventoryKit, value: "Cracked", comment: "State: Cracked")
            case .trainer: return NSLocalizedString("state.trainer", bundle: .inventoryKit, value: "Trainer / Cheat", comment: "State: Trainer")
            case .verifiedClean: return NSLocalizedString("state.verifiedClean", bundle: .inventoryKit, value: "Verified Clean", comment: "State: Verified Clean")
            case .originalDump: return NSLocalizedString("state.originalDump", bundle: .inventoryKit, value: "Original Dump", comment: "State: Original Dump")
            }
        }
    }
    
    public enum Manufacturer: String, CaseIterable, Sendable, Codable {
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
            case .publisher: return NSLocalizedString("mfg.publisher", bundle: .inventoryKit, value: "Software Publisher", comment: "Mfg: Publisher")
            case .developer: return NSLocalizedString("mfg.developer", bundle: .inventoryKit, value: "Software Developer", comment: "Mfg: Developer")
            case .hardware: return NSLocalizedString("mfg.hardware", bundle: .inventoryKit, value: "Hardware Manufacturer", comment: "Mfg: Hardware")
            case .indie: return NSLocalizedString("mfg.indie", bundle: .inventoryKit, value: "Indie Developer", comment: "Mfg: Indie")
            case .active: return NSLocalizedString("mfg.active", bundle: .inventoryKit, value: "Active", comment: "Mfg: Active")
            case .defunct: return NSLocalizedString("mfg.defunct", bundle: .inventoryKit, value: "Defunct", comment: "Mfg: Defunct")
            case .acquired: return NSLocalizedString("mfg.acquired", bundle: .inventoryKit, value: "Acquired", comment: "Mfg: Acquired")
            case .merged: return NSLocalizedString("mfg.merged", bundle: .inventoryKit, value: "Merged", comment: "Mfg: Merged")
            }
        }
    }
    
    public enum Region: String, CaseIterable, Sendable, Codable {
        case ntsc = "region:ntsc"
        case pal = "region:pal"
        case usa = "region:usa"
        case eur = "region:eur"
        case jpn = "region:jpn"
        
        public var localizedLabel: String {
            switch self {
            case .ntsc: return NSLocalizedString("region.ntsc", bundle: .inventoryKit, value: "NTSC", comment: "Region: NTSC")
            case .pal: return NSLocalizedString("region.pal", bundle: .inventoryKit, value: "PAL", comment: "Region: PAL")
            case .usa: return NSLocalizedString("region.usa", bundle: .inventoryKit, value: "North America (USA)", comment: "Region: USA")
            case .eur: return NSLocalizedString("region.eur", bundle: .inventoryKit, value: "Europe", comment: "Region: Europe")
            case .jpn: return NSLocalizedString("region.jpn", bundle: .inventoryKit, value: "Japan", comment: "Region: Japan")
            }
        }
    }

    public enum Acquisition: String, CaseIterable, Sendable, Codable {
        case purchase = "acq:purchase"
        case gift = "acq:gift"
        case donation = "acq:donation"
        case bequest = "acq:bequest"
        case found = "acq:found"
        case trade = "acq:trade"
        case unknown = "acq:unknown"
        
        public var localizedLabel: String {
            switch self {
            case .purchase: return NSLocalizedString("acq.purchase", bundle: .inventoryKit, value: "Purchased", comment: "Acq: Purchase")
            case .gift: return NSLocalizedString("acq.gift", bundle: .inventoryKit, value: "Gifted", comment: "Acq: Gift")
            case .donation: return NSLocalizedString("acq.donation", bundle: .inventoryKit, value: "Donated", comment: "Acq: Donation")
            case .bequest: return NSLocalizedString("acq.bequest", bundle: .inventoryKit, value: "Bequest", comment: "Acq: Bequest")
            case .found: return NSLocalizedString("acq.found", bundle: .inventoryKit, value: "Found", comment: "Acq: Found")
            case .trade: return NSLocalizedString("acq.trade", bundle: .inventoryKit, value: "Traded", comment: "Acq: Trade")
            case .unknown: return NSLocalizedString("acq.unknown", bundle: .inventoryKit, value: "Unknown", comment: "Acq: Unknown")
            }
        }
    }



    // MARK: - New Domains
    
    public enum Interface: String, CaseIterable, Sendable, Codable {
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
            case .usb: return NSLocalizedString("interface.usb", bundle: .inventoryKit, value: "USB", comment: "Interface: USB")
            case .serial: return NSLocalizedString("interface.serial", bundle: .inventoryKit, value: "Serial", comment: "Interface: Serial")
            case .parallel: return NSLocalizedString("interface.parallel", bundle: .inventoryKit, value: "Parallel", comment: "Interface: Parallel")
            case .ps2: return NSLocalizedString("interface.ps2", bundle: .inventoryKit, value: "PS/2", comment: "Interface: PS/2")
            case .adb: return NSLocalizedString("interface.adb", bundle: .inventoryKit, value: "ADB (Apple Desktop Bus)", comment: "Interface: ADB")
            case .scsi: return NSLocalizedString("interface.scsi", bundle: .inventoryKit, value: "SCSI", comment: "Interface: SCSI")
            case .ide: return NSLocalizedString("interface.ide", bundle: .inventoryKit, value: "IDE / PATA", comment: "Interface: IDE")
            case .midi: return NSLocalizedString("interface.midi", bundle: .inventoryKit, value: "MIDI", comment: "Interface: MIDI")
            case .gameport: return NSLocalizedString("interface.gameport", bundle: .inventoryKit, value: "Gameport", comment: "Interface: Gameport")
            case .proprietary: return NSLocalizedString("interface.proprietary", bundle: .inventoryKit, value: "Proprietary", comment: "Interface: Proprietary")
            }
        }
    }
    
    public enum Material: String, CaseIterable, Sendable, Codable {
        case plastic = "material:plastic"
        case metal = "material:metal"
        case wood = "material:wood"
        case paper = "material:paper"
        case cardboard = "material:cardboard"
        
        public var localizedLabel: String {
            switch self {
            case .plastic: return NSLocalizedString("material.plastic", bundle: .inventoryKit, value: "Plastic", comment: "Material: Plastic")
            case .metal: return NSLocalizedString("material.metal", bundle: .inventoryKit, value: "Metal", comment: "Material: Metal")
            case .wood: return NSLocalizedString("material.wood", bundle: .inventoryKit, value: "Wood", comment: "Material: Wood")
            case .paper: return NSLocalizedString("material.paper", bundle: .inventoryKit, value: "Paper", comment: "Material: Paper")
            case .cardboard: return NSLocalizedString("material.cardboard", bundle: .inventoryKit, value: "Cardboard", comment: "Material: Cardboard")
            }
        }
    }
    
    public enum MediaFormat: String, CaseIterable, Sendable, Codable {
        case vhs = "media:vhs"
        case dvd = "media:dvd"
        case cd = "media:cd"
        case vinyl = "media:vinyl"
        case cassetteAudio = "media:cassette_audio"
        case laserdisc = "media:laserdisc"
        
        public var localizedLabel: String {
            switch self {
            case .vhs: return NSLocalizedString("media.vhs", bundle: .inventoryKit, value: "VHS", comment: "Media: VHS")
            case .dvd: return NSLocalizedString("media.dvd", bundle: .inventoryKit, value: "DVD", comment: "Media: DVD")
            case .cd: return NSLocalizedString("media.cd", bundle: .inventoryKit, value: "CD / CD-ROM", comment: "Media: CD")
            case .vinyl: return NSLocalizedString("media.vinyl", bundle: .inventoryKit, value: "Vinyl Record", comment: "Media: Vinyl")
            case .cassetteAudio: return NSLocalizedString("media.cassetteAudio", bundle: .inventoryKit, value: "Audio Cassette", comment: "Media: Cassette")
            case .laserdisc: return NSLocalizedString("media.laserdisc", bundle: .inventoryKit, value: "LaserDisc", comment: "Media: LaserDisc")
            }
        }
    }
}
