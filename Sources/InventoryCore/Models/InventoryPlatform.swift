import Foundation

/// Standardized Platform Identifiers for the Retro Ecosystem.
/// Used to bucket software and hardware into ecosystem-compatible groups.
public enum InventoryPlatform: String, Codable, CaseIterable, Sendable {
    
    // MARK: - Apple
    case appleII = "apple2"
    case appleIIGS = "apple2gs"
    case appleIII = "apple3"
    case appleLisa = "lisa"
    case macintosh = "mac"
    
    // MARK: - Commodore
    case c64 = "c64"
    case c128 = "c128"
    case vic20 = "vic20"
    case pet = "pet"
    case amiga = "amiga"
    case amigaCD32 = "amiga_cd32"
    
    // MARK: - Atari
    case atari2600 = "atari_2600"
    case atari5200 = "atari_5200"
    case atari7800 = "atari_7800"
    case atari8bit = "atari_8bit"
    case atariST = "atari_st"
    case atariLynx = "atari_lynx"
    case atariJaguar = "atari_jaguar"
    
    // MARK: - Microsoft / PC
    case dos = "dos"
    case win3x = "win3x"
    case win9x = "win9x"
    
    // MARK: - Nintendo
    case nes = "nes"
    case snes = "snes"
    case n64 = "n64"
    case gameboy = "gameboy"
    case gameboyColor = "gbc"
    case gameboyAdvance = "gba"
    
    // MARK: - Sega
    case masterSystem = "sms"
    case genesis = "genesis"
    case gameGear = "gamegear"
    case saturn = "saturn"
    case dreamcast = "dreamcast"
    
    // MARK: - Other
    case msx = "msx"
    case zxSpectrum = "zx_spectrum"
    case amstradCPC = "amstrad_cpc"
    case neogeo = "neogeo"
    case unknown = "unknown"
    
    /// Returns a human-readable display name.
    public var displayName: String {
        switch self {
        case .appleII: return "Apple II"
        case .appleIIGS: return "Apple IIGS"
        case .appleIII: return "Apple III"
        case .appleLisa: return "Apple Lisa"
        case .macintosh: return "Macintosh"
            
        case .c64: return "Commodore 64"
        case .c128: return "Commodore 128"
        case .vic20: return "VIC-20"
        case .pet: return "Commodore PET"
        case .amiga: return "Amiga"
        case .amigaCD32: return "Amiga CD32"
            
        case .atari2600: return "Atari 2600"
        case .atari5200: return "Atari 5200"
        case .atari7800: return "Atari 7800"
        case .atari8bit: return "Atari 8-bit"
        case .atariST: return "Atari ST/TT/Falcon"
        case .atariLynx: return "Atari Lynx"
        case .atariJaguar: return "Atari Jaguar"
            
        case .dos: return "MS-DOS"
        case .win3x: return "Windows 3.x"
        case .win9x: return "Windows 9x"
            
        case .nes: return "Nintendo Entertainment System"
        case .snes: return "Super Nintendo"
        case .n64: return "Nintendo 64"
        case .gameboy: return "Game Boy"
        case .gameboyColor: return "Game Boy Color"
        case .gameboyAdvance: return "Game Boy Advance"
            
        case .masterSystem: return "Sega Master System"
        case .genesis: return "Sega Genesis / Mega Drive"
        case .gameGear: return "Sega Game Gear"
        case .saturn: return "Sega Saturn"
        case .dreamcast: return "Sega Dreamcast"
            
        case .msx: return "MSX"
        case .zxSpectrum: return "ZX Spectrum"
        case .amstradCPC: return "Amstrad CPC"
        case .neogeo: return "Neo Geo"
        case .unknown: return "Unknown"
        }
    }
}
