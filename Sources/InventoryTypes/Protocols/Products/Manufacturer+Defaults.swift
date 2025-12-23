
import Foundation

public extension Manufacturer {
    var alsoKnownAs: [String] { [] }
    var alternativeSpellings: [String] { [] }
    var commonMisspellings: [String] { [] }
    var addresses: [any Address] { [] }
    var email: String? { nil }
    var associatedPeople: [any Contact] { [] }
    var developers: [any Contact] { [] }
}
