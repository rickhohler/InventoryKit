
import Foundation

public extension InventoryManufacturer {
    var alsoKnownAs: [String] { [] }
    var alternativeSpellings: [String] { [] }
    var commonMisspellings: [String] { [] }
    var addresses: [any InventoryAddress] { [] }
    var email: String? { nil }
    var associatedPeople: [any InventoryContact] { [] }
    var developers: [any InventoryContact] { [] }
}
