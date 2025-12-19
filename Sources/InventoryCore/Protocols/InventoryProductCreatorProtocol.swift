//
//  InventoryProductCreatorProtocol.swift
//  InventoryKit
//
//  Protocol for product creator information (ISP - Interface Segregation)
//

import Foundation

/// Protocol for product creator/publisher information.
///
/// Separated creator/publisher concerns.
/// Part of the Interface Segregation Principle (ISP) - focused protocol.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryProductCreatorProtocol: Sendable {
    /// Manufacturer name (for hardware) or publisher (for software).
    var manufacturer: String? { get }
    
    /// Publisher name (for software).
    var publisher: String? { get }
    
    /// Developer name.
    var developer: String? { get }
    
    /// Individual creator/designer.
    var creator: String? { get }
}

