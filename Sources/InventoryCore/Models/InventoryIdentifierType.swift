import Foundation

public enum InventoryIdentifierType: String, Codable, Sendable {
    case nfcTag = "nfc_tag"
    case qrCode = "qr_code"
    case barcode = "barcode"
    case libraryReferenceID = "library_reference_id"
    case libraryID = "library_id"
    case serialNumber = "serial_number"
}
