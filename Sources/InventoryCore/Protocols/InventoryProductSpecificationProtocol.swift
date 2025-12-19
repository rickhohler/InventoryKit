//
//  InventoryProductSpecificationProtocol.swift
//  InventoryKit
//
//  Protocol for product specifications (ISP - Interface Segregation)
//

import Foundation

/// Protocol for product specifications.
///
/// Separated specification concerns for both hardware and software products.
/// Part of the Interface Segregation Principle (ISP) - focused protocol.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryProductSpecificationProtocol: Sendable {
    /// Platform (e.g., "Apple II", "Commodore 64").
    var platform: String? { get }
    
    /// System requirements (for software) or general technical info.
    var systemRequirements: String? { get }
    
    /// Software version (for software products).
    var version: String? { get }
    
    /// Genre or category (for software products).
    var genre: String? { get }
    
    /// Model numbers for hardware products (e.g., "A2S2000" for Apple IIe).
    var modelNumbers: [String] { get }
    
    /// Hardware specifications (CPU, RAM, storage, ports, etc.).
    var hardwareSpecs: HardwareSpecification? { get }
    
    /// Hardware features (e.g., "80-column card", "Extended 80-column card", "RGB monitor support").
    var features: [String] { get }
}

