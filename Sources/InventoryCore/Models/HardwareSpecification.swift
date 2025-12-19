//
//  HardwareSpecification.swift
//  InventoryKit
//
//  Hardware specification model for hardware products
//

import Foundation

/// Hardware specifications for hardware products.
///
/// Contains detailed technical specifications for hardware products like computers,
/// peripherals, and other physical devices. This is separate from the general Product
/// metadata and provides structured hardware-specific information.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct HardwareSpecification: Sendable, Codable, Hashable {
    /// CPU/Processor information
    public let processor: String?
    
    /// Processor speed (MHz, GHz, etc.)
    public let processorSpeed: String?
    
    /// RAM/Memory specifications
    public let memory: String?
    
    /// Storage specifications (hard drive, disk drive, etc.)
    public let storage: String?
    
    /// Display specifications (for monitors/displays)
    public let display: String?
    
    /// Graphics specifications
    public let graphics: String?
    
    /// Audio specifications
    public let audio: String?
    
    /// Ports and connectors
    public let ports: [String]
    
    /// Expansion slots
    public let expansionSlots: [String]
    
    /// Physical dimensions (width x height x depth, weight)
    public let dimensions: String?
    
    /// Power requirements
    public let powerRequirements: String?
    
    /// Operating system (if applicable)
    public let operatingSystem: String?
    
    /// Additional technical specifications
    public let additionalSpecs: [String: String]
    
    public init(
        processor: String? = nil,
        processorSpeed: String? = nil,
        memory: String? = nil,
        storage: String? = nil,
        display: String? = nil,
        graphics: String? = nil,
        audio: String? = nil,
        ports: [String] = [],
        expansionSlots: [String] = [],
        dimensions: String? = nil,
        powerRequirements: String? = nil,
        operatingSystem: String? = nil,
        additionalSpecs: [String: String] = [:]
    ) {
        self.processor = processor
        self.processorSpeed = processorSpeed
        self.memory = memory
        self.storage = storage
        self.display = display
        self.graphics = graphics
        self.audio = audio
        self.ports = ports
        self.expansionSlots = expansionSlots
        self.dimensions = dimensions
        self.powerRequirements = powerRequirements
        self.operatingSystem = operatingSystem
        self.additionalSpecs = additionalSpecs
    }
}

