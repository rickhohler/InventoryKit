//
//  ProductType.swift
//  InventoryKit
//
//  Product type enumeration
//

import Foundation

/// Product type enumeration.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum ProductType: String, Sendable, Codable {
    case software
    case hardware
}

