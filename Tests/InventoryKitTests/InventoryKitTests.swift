import Foundation
import Testing
@testable import InventoryKit

@Test func schemaVersionParsing() async throws {
    let version = try InventorySchemaVersion("1.2.3-alpha+local")
    #expect(version.major == 1)
    #expect(version.minor == 2)
    #expect(version.patch == 3)
    #expect(version.prerelease == "alpha")
    #expect(version.buildMetadata == "local")

    let newer = InventorySchemaVersion(major: 1, minor: 3, patch: 0)
    #expect(newer.isCompatible(with: version))
    #expect(newer > version)
}

@Test func codecDecodesInventory() async throws {
    let yaml = """
    schemaVersion: 1.0.0
    metadata:
      generatedAt: 2025-01-01T00:00:00Z
      owner: platform
    assets:
      - id: 11111111-1111-1111-1111-111111111111
        name: Web Server
        type: server
        location: primary
        tags:
          - production
          - critical
        metadata:
          cpu: "8"
          memory: "32GB"
      - id: 22222222-2222-2222-2222-222222222222
        name: User Database
        type: database
        tags: []
        metadata: {}
    """

    let codec = InventoryCodec()
    let document = try codec.decode(from: Data(yaml.utf8))
    #expect(document.assets.count == 2)
    #expect(document.metadata["owner"] == "platform")
    #expect(document.assets.first?.metadata["cpu"] == "8")
}

@Test func codecRejectsIncompatibleSchema() async throws {
    let yaml = """
    schemaVersion: 2.0.0
    assets: []
    """

    let codec = InventoryCodec()
    await #expect(throws: InventoryError.schemaIncompatible(expected: .current, actual: InventorySchemaVersion(major: 2, minor: 0, patch: 0))) {
        _ = try codec.decode(from: Data(yaml.utf8))
    }
}

@Test func encodeRoundTrip() async throws {
    let assetID = UUID(uuidString: "77777777-7777-7777-7777-777777777777")!
    let asset = InventoryAsset(
        id: assetID,
        name: "Telemetry Node",
        type: "server",
        location: "lab",
        identifiers: [
            InventoryIdentifier(type: .uuid, value: assetID.uuidString),
            InventoryIdentifier(type: .serialNumber, value: "SRV-100")
        ],
        tags: ["lab", "telemetry"],
        metadata: ["cpu": "16"]
    )
    let document = InventoryDocument(
        schemaVersion: .current,
        metadata: ["owner": "infra"],
        assets: [asset]
    )

    let codec = InventoryCodec()
    let yaml = try codec.encode(document)
    let decoded = try codec.decode(from: Data(yaml.utf8))
    #expect(decoded == document)
}

@Test func catalogResolvesIdentifiersAndRelationships() async throws {
    let computerID = UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")!
    let keyboardID = UUID(uuidString: "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb")!

    let keyboard = InventoryAsset(
        id: keyboardID,
        name: "Model M Keyboard",
        type: "keyboard",
        identifiers: [
            InventoryIdentifier(type: .uuid, value: keyboardID.uuidString),
            InventoryIdentifier(type: .serialNumber, value: "KB-1987")
        ],
        tags: ["peripheral", "ibm"]
    )

    let computer = InventoryAsset(
        id: computerID,
        name: "IBM PC/AT",
        type: "computer",
        relationshipRequirements: [
            InventoryRelationshipRequirement(
                name: "Keyboard",
                typeID: "keyboard",
                required: true,
                compatibleAssetIDs: [keyboardID],
                requiredTags: ["peripheral"]
            )
        ],
        linkedAssets: [
            InventoryLinkedAsset(assetID: keyboardID, typeID: "keyboard")
        ],
        tags: ["vintage"]
    )

    let document = InventoryDocument(
        schemaVersion: .current,
        relationshipTypes: [
            InventoryRelationshipType(id: "keyboard", displayName: "Keyboard", description: "Input device")
        ],
        assets: [computer, keyboard]
    )

    let catalog = InventoryCatalog(document: document)
    #expect(await catalog.totalAssetCount == 2)

    let resolvedBySerial = await catalog.asset(identifierType: .serialNumber, value: "KB-1987")
    #expect(resolvedBySerial?.id == keyboardID)

    let relationships = await catalog.evaluateRelationships(forAssetID: computerID)
    #expect(relationships.count == 1)
    #expect(relationships.first?.status == .satisfied)
}

