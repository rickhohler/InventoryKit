import Foundation

public enum IdentifierType: String, Codable, Sendable {
    case nfcTag = "nfc_tag"
    case qrCode = "qr_code"
    case barcode = "barcode"
    case libraryReferenceID = "library_reference_id"
    case libraryID = "library_id"
    case serialNumber = "serial_number"
    
    /// Alias for `.barcode`, reflecting retro terminology (1977-2000).
    public static let upc = Self.barcode
}
