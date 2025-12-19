//
//  InventoryProductIdentificationProtocol.swift
//  InventoryKit
//
//  Protocol for product identification (ISP - Interface Segregation)
//

import Foundation

/// Protocol for product identification.
///
/// Provides minimal interface for basic product identification.
/// Part of the Interface Segregation Principle (ISP) - focused protocol.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryProductIdentificationProtocol: Identifiable, Sendable where ID == UUID {
    /// Unique identifier for the product.
    var id: UUID { get }
    
    /// Museum-style accession number (optional).
    var accessionNumber: String? { get }
}

