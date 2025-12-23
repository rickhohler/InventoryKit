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
    
    /// Returns a human-readable label for the format.
    public var label: String {
        switch self {
        case .cassette: return NSLocalizedString("Compact Cassette", bundle: .module, comment: "Media Format: Cassette")
        case .datTape: return NSLocalizedString("DAT Tape", bundle: .module, comment: "Media Format: DAT Tape")
        case .reelToReel: return NSLocalizedString("Reel-to-Reel Tape", bundle: .module, comment: "Media Format: Reel-to-Reel")
        case .floppy525: return NSLocalizedString("5.25\" Floppy Disk", bundle: .module, comment: "Media Format: 5.25 Inch Floppy")
        case .floppy35: return NSLocalizedString("3.5\" Floppy Disk", bundle: .module, comment: "Media Format: 3.5 Inch Floppy")
        case .floppy8: return NSLocalizedString("8\" Floppy Disk", bundle: .module, comment: "Media Format: 8 Inch Floppy")
        case .cdRom: return NSLocalizedString("CD-ROM", bundle: .module, comment: "Media Format: CD-ROM")
        case .dvdRom: return NSLocalizedString("DVD-ROM", bundle: .module, comment: "Media Format: DVD-ROM")
        case .laserDisc: return NSLocalizedString("LaserDisc", bundle: .module, comment: "Media Format: LaserDisc")
        case .cartridge: return NSLocalizedString("Cartridge", bundle: .module, comment: "Media Format: Cartridge")
        case .sdCard: return NSLocalizedString("SD Card", bundle: .module, comment: "Media Format: SD Card")
        case .compactFlash: return NSLocalizedString("CompactFlash", bundle: .module, comment: "Media Format: CompactFlash")
        case .pcmcia: return NSLocalizedString("PCMCIA Card", bundle: .module, comment: "Media Format: PCMCIA")
        case .usbDrive: return NSLocalizedString("USB Flash Drive", bundle: .module, comment: "Media Format: USB Drive")
        case .digital: return NSLocalizedString("Digital Download", bundle: .module, comment: "Media Format: Digital Download")
        case .other: return NSLocalizedString("Other", bundle: .module, comment: "Media Format: Other")
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
