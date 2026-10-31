import Foundation

/// Defines the specific physical format of the media.
/// Used to distinguish between different physical carriers of software/data.
public enum MediaFormatType: String, Codable, Sendable, CaseIterable {
    // Magnetic Media - Tape
    case cassette
    case datTape = "dat_tape"
    case reelToReel = "reel_to_reel"
    
    // Magnetic Media - Floppy
    case floppy525  = "floppy_5_25"
    case floppy35   = "floppy_3_5"
    case floppy8    = "floppy_8"
    
    // Optical Media
    case cdRom = "cd_rom"
    case dvdRom = "dvd_rom"
    case laserDisc = "laser_disc"
    
    // Solid State
    case cartridge
    case sdCard       // Secure Digital (SD, microSD)
    case compactFlash // CompactFlash (CF)
    case pcmcia       // PC Card
    case usbDrive     // USB Flash Drive, Thumb Drive
    
    
    // Other
    case digital // Pure digital file (no physical carrier)
    case other   // Ambiguous or other
    
    /// Returns a human-readable label for the format, looked up with `InventoryLocalizedString`
    /// under `media_format.<rawValue>` so a client app's strings table can override it.
    public var label: String {
        InventoryLocalizedString("media_format.\(rawValue)", value: englishLabel, comment: "Media format label")
    }

    /// The English label, used when no table has the key.
    private var englishLabel: String {
        switch self {
        case .cassette: return "Compact Cassette"
        case .datTape: return "DAT Tape"
        case .reelToReel: return "Reel-to-Reel Tape"
        case .floppy525: return "5.25\" Floppy Disk"
        case .floppy35: return "3.5\" Floppy Disk"
        case .floppy8: return "8\" Floppy Disk"
        case .cdRom: return "CD-ROM"
        case .dvdRom: return "DVD-ROM"
        case .laserDisc: return "LaserDisc"
        case .cartridge: return "Cartridge"
        case .sdCard: return "SD Card"
        case .compactFlash: return "CompactFlash"
        case .pcmcia: return "PCMCIA Card"
        case .usbDrive: return "USB Flash Drive"
        case .digital: return "Digital Download"
        case .other: return "Other"
        }
    }
    
    /// Returns the Wikipedia URL for this media format.
    public var wikipediaURL: URL? {
        switch self {
        case .cassette: return URL(string: "https://en.wikipedia.org/wiki/Compact_Cassette")
        case .datTape: return URL(string: "https://en.wikipedia.org/wiki/Digital_Audio_Tape")
        case .reelToReel: return URL(string: "https://en.wikipedia.org/wiki/Reel-to-reel_audio_tape_recording")
        case .floppy525: return URL(string: "https://en.wikipedia.org/wiki/Floppy_disk#5%C2%BC-inch_minifloppy")
        case .floppy35: return URL(string: "https://en.wikipedia.org/wiki/Floppy_disk#3%C2%BD-inch_microfloppy")
        case .floppy8: return URL(string: "https://en.wikipedia.org/wiki/Floppy_disk#8-inch_floppy_disk")
        case .cdRom: return URL(string: "https://en.wikipedia.org/wiki/CD-ROM")
        case .dvdRom: return URL(string: "https://en.wikipedia.org/wiki/DVD")
        case .laserDisc: return URL(string: "https://en.wikipedia.org/wiki/LaserDisc")
        case .cartridge: return URL(string: "https://en.wikipedia.org/wiki/ROM_cartridge")
        case .sdCard: return URL(string: "https://en.wikipedia.org/wiki/SD_card")
        case .compactFlash: return URL(string: "https://en.wikipedia.org/wiki/CompactFlash")
        case .pcmcia: return URL(string: "https://en.wikipedia.org/wiki/PC_Card")
        case .usbDrive: return URL(string: "https://en.wikipedia.org/wiki/USB_flash_drive")
        case .digital: return URL(string: "https://en.wikipedia.org/wiki/Digital_distribution")
        case .other: return nil
        }
    }
}
