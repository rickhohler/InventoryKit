import Foundation

/// Represents a digital storage volume (e.g., Hard Drive, Cloud Storage, NAS).
public protocol DigitalVolume: Space {
    /// The root URI of the volume (e.g., "file:///DigitalVolumes/Data").
    var uri: URL { get set }
}
