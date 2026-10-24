# InventoryKit Terminology

Glossary of the types InventoryKit defines; this file explains the vocabulary. Concepts that apps build on top of InventoryKit but that have no type here are listed at the end.

## Shared base types

- **InventoryCompoundBase**: base protocol for any logical unit that holds content, public or private: `id`, `title`, `description`, `manufacturer`, `releaseDate`, `dataSource`, `children: [InventoryItem]`, `images: [InventoryItem]`.
- **InventoryItem**: metadata record for a single component (file, chip, board): name, size or weight, type identifier, hashes or serial number, `typeClassifier` (`ItemClassifierType`), `mediaFormat`, identifiers, `productID`, source code, container and location.
- **Product**: the authority record that describes a product line or creative work (identity, metadata, creators, dates, platform string, system requirements, related IDs, references).

## Private (user) entities

- **InventoryAsset**: an item in the user's possession. It is an `InventoryCompoundBase` and an `InventoryItem`, with custody location, provenance, acquisition, condition, tags, metadata, links (`linkedAssets`), components and relationship requirements.
- **InventoryAssetComponent**: an `InventoryItem` inside an asset with forensic and physical state.
- **DraftAsset**: a detached copy of an asset with staged metadata and tags for editing.
- **WorkbenchItem / WorkbenchService**: a mutable working copy of an asset (`checkout`, `save`, `commit`, `discard`); protocols only.

## Reference (public library) entities

- **ReferenceManufacturer**: the company or person who created a product (`Manufacturer` + slug and images). Contacts and addresses come from `Contact` and `Address`.
- **ReferenceProduct**: a catalog entry: a `Product` that is also an `InventoryCompoundBase`, with Wikipedia/purchase/manual URLs, platforms, country and copyright registration.
- **ReferenceItem**: metadata for a file that should exist in a reference product (expected checksums, variant).
- **ReferenceLibrary**: a `DataSource` (archive, museum, database, ...) that provides catalog data; `isVerified`.
- **ReferenceCollection**: a `Collection` curated by a library, with an info URL.
- **Vendor**: an organization record used by `InventoryStorageProvider` vendor operations.

## Identification

- **InventoryIdentifier / IdentifierModel**: typed identifier (`nfc_tag`, `qr_code`, `barcode` (alias `upc`), `library_reference_id`, `library_id`, `serial_number`) plus value.
- **Inventory Resource Name (IRN)**: `inventory:<public|private>:<service>:<namespace>:<type>:<id>`, built with `InventoryResourceNameBuilder`.
- **InventoryIDGenerator**: deterministic UUIDv5 per `InventoryNamespace` (manufacturer, product, person, library, platform).
- **SchemaVersion**: semantic version of the inventory document schema.

## Classification and tags

- **ItemClassifierType**: software, firmware, disk image, archive, document, multimedia, graphic, tape image, computer hardware, peripheral, physical item, storage container, physical software, other; each is physical or digital.
- **MediaFormatType**: physical carrier (floppy sizes, tape, optical, cartridge, flash, digital, other).
- **PackageContentsType**: what came in the package (box, manual, media, extras), with CIB composites.
- **TagType**: namespaced tag vocabulary (`condition:`, `format:`, `content:`, `state:`, `type:`/`status:`, `region:`, `acq:`, `interface:`, `material:`, `media:`).
- **Questionnaire**: answers about an item or manufacturer that generate tags and metadata attributes.

## Relationships

- **AssetRelationshipType**: `variant_of`, `derived_from`, `component_of`, `contained_in`, `requires`, `bundled_with`.
- **InventoryRelationshipRequirement**: what an asset needs (`typeID`, `required`, `compatibleAssetIDs`, `requiredTags`).
- **InventoryLinkedAsset / LinkedAsset**: a link from an asset to another asset with a `typeID`.
- **InventoryRelationshipEvaluation**: result of checking one requirement (satisfied, missing required/optional, incompatible, non-compliant tags).

## Locations and containers

- **Space**: anything that can hold items: `Building`, `Room` (in a building, with a level) and `DigitalVolume` (URI). Concrete models: `InventoryBuilding`, `InventoryRoom`, `InventoryDigitalVolume`.
- **ItemContainer**: a box, bin or folder holding items (`ItemContainerPhysical`, `ItemContainerDigital`), identified by NFC/QR/barcode identifiers.
- **ItemLocationType**: `.physical(roomID, exactLocation, geoLocation)` or `.digital(url, volumeID)`.

## Storage roles

- **StorageProvider**: the client's storage: repositories (`StorageConfigurator`), user/reference metadata stores, user/reference data stores (files), transactions.
- **Configurator**: the client's writer that populates its concrete types for InventoryKit services.
- **Context**: storage + configurator handed to services.

## App-level concepts (no type in InventoryKit)

These appear in Retrobox and catalog-stack designs. InventoryKit has no types or behavior for them: library consortium and union catalog, content-addressed asset and reference data stores, custom (user-defined) manufacturers and products, contribution requests and the curator review workflow, collection bundles and retroactive matching. Retrobox's design notes for contributions were removed from this repo (see git history for `docs/SUBMISSION_DESIGN.md`) and belong with the app or RetroMisc.
