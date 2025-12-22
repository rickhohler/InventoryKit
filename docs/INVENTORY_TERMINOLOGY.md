# InventoryKit Terminology

This document defines the core terminology used within the **InventoryKit** system to ensure clarity between Physical/Digital inventory management and Catalog data sourcing.

## 1. Shared Base Types (Polymorphic)

The application unifies Private and Public data using these abstract base definitions.

### InventoryCompoundBase ("The Bundle Base")
*   **Definition**: The abstract base type for **ANY** compound group of files/items (Public or Private).
*   **Role**: Represents a logical unit that holds content.
*   **Shared Contract**:
    *   **Identity**: `id`, `title`, `description`.
    *   **Metadata**: `manufacturer`, `releaseDate`, `tags`, `product: InventoryProduct?`.
    *   **Structure**: `children: [InventoryItem]`.
    *   **Visual Representation**: `images: [InventoryItem]` (Photos of the hardware/box).
    *   **Source**: `dataSource` (Where did this description come from?).

### InventoryProduct ("The Definition")
*   **Definition**: The abstract "Authority Record" that describes a product line or creative work.
*   **Role**: Acts as the official **Identity** (Software/Hardware Spec) for Assets.
*   **Contrast**: `CompoundResource` is the *Package/Container* of files; `InventoryProduct` is the *Concept/Identity* of what those files are.
*   **Usage**:
    *   **Public**: Downloadable Metadata for matching.
    *   **Private**: Extracted Metadata from a user's file (e.g. valid file header info).
*   **Key Attributes**: `manufacturer`, `releaseDate`, `sku`, `title`, `sourceCode` (Availability).
*   **Distinction vs Collection**:
    *   **Compound Base**: Parts are **Dependent** and form a **Single Atomic Item** (e.g. Box + Disk = 1 Game).
    *   **Collection**: Members are **Independent** and form a **Group/List** (e.g. Game A + Game B = 2 Games).
*   **Conforming Types**:
    *   **Public**: `Compound Resource` (Archive.org Item).
    *   **Private**: `Inventory Asset` (User Box/Folder).

### InventoryItem ("The File/Part Record")
*   **Definition**: The abstract base type for the **Metadata Record** describing a single component (File, Chip, PCB).
*   **Role**: Describes the properties of a component in the catalog.
*   **Shared Contract**:
    *   **Properties**: `name/filename`, `size/weight`, `type` (UTI/Part#).
    *   **Verification**: `fileHashes` (Digital) OR `serialNumber` (Physical).
    *   **Classification**: `typeClassifier` (Software, Firmware, DiskImage, Archive, Document, Hardware, etc.).
    *   **Identifiers**: `identifiers: [InventoryIdentifier]` (NFC, QR Code, Barcode, Public Library ID).
    *   **Source Code**: `sourceCode` (Repository URL, License, Notes).
*   **Conforming Types**:
    *   **Public**: `Public Resource` (File or Hardware Spec).
    *   **Private**: `Inventory Asset Component` (File or Physical Part).

---

## 2. Private Domain Entities (Personal Archive)

### Inventory Asset ("The User Item")
*   **Definition**: A concrete instance of an **InventoryCompoundBase** in the user's possession.
*   **Conforms To**: `InventoryCompoundBase` (Title, Metadata, Children).
*   **Context**:
    *   **Physical**: A "Big Box" game containing a Floppy Disk, Manual, and Map.
    *   **Hardware**: An "Apple IIe Computer" (Container) containing "Motherboard", "Disk II Card", "Power Supply".
    *   **Digital**: A folder containing `game.dsk`, `manual.pdf`, and `cover.jpg`.
*   **User-Specific Attributes** (extends Base):
<<<<<<< HEAD
    *   **Custody**: Storage location (e.g., "Shelf A").
    *   **Provenance**: History of *this specific instance* (e.g., "Bought 1983", "Dumped by 4am").
=======
    *   **Custody**: Storage location (managed via `ItemLocation` / `ItemContainer`).
    *   **Provenance**: History of *this specific instance* (e.g., "Bought 1983").
>>>>>>> main
    *   **Condition**: Physical/Digital state (e.g. "Mint", "Corrupted").
    *   **Ownership Status**: "Owned" vs "Possessed" vs "Wishlist".
*   **Foreign references**:
    *   **`referenceProductID`**: Links this User Asset to the **ReferenceProduct** (Authority Record).
    *   **`manufacturer`**: Links to the **ReferenceManufacturer** (The Creator/Author).
*   **Children**: Contains `InventoryAssetComponents` (which conform to `InventoryItem`).
*   **Example**: "Ultima IV Box (StorageContainer)" -> contains -> "Game Disk (DiskImage)", "Cloth Map (Graphic)", "Manual (Document)".

### Inventory Asset Component ("The User File/Part")
*   **Definition**: A concrete instance of an **InventoryItem** inside an Asset.
*   **Conforms To**: `InventoryItem` (Filename, Hashes, Classifier).
*   **User-Specific Attributes**:
    *   **Forensic State**: "Original Dump", "Cracked", "Modified".
    *   **Physical State**: "Capacitor Leaking", "Tested OK".
*   **Example**: The `game_cracked.dsk` file OR The `6502 CPU` chip.
*   **Note**: An item in the Public Catalog (e.g., a file on Archive.org) is a **Public Resource**, not an Asset, until the user downloads/acquires it.

### Asset Data Store ("The Private Vault")
*   **Definition**: The local repository where the user's actual **Inventory Asset** files are stored.
*   **Structure**: Uses a **Git-style directory structure** (Content-Addressable Storage / Objects folder).
*   **Role**: Acts as the user's **Personal Archive** within the greater Library Consortium.
*   **Realm**: Private Inventory Realm.

### CustomManufacturer ("The Private Creator")
*   **Definition**: A local-only manufacturer/creator defined by the user for items NOT in the Reference Catalog.
*   **Conforms To**: `InventoryManufacturer` (ID, Name).
*   **UI Label**: "**Custom**" or "**Other**".
*   **Context**: "My friend made this game", "Unknown Indie Dev".
*   **Storage**: Stored in the User's Private Database.
*   **Role**: Allows valid data structure without polluting the Curated Reference Manufacturer list.

---

## 3. Reference Domain Entities (The Public Library)

### ReferenceLibrary ("The Provider")
*   **Definition**: The entity or organization that *provides* the catalog data, metadata, or curated collections.
*   **Previous Term**: Inventory Data Source.
*   **Context**: The "Source of Truth" for the catalog (e.g., Archive.org, MobyGames).
*   **Key Attributes**:
    *   **Reliability**: Is this a trusted source? (e.g., Verified).
    *   **Type**: Archive, Museum, Database, Community.
    *   **Transport**: The protocol used to fetch data (`https`, `ssh`, `ftp`, `s3`).
*   **Example**: **Archive.org** (Transport: `ia_swift` - Custom implementation of Python archive.org library), **MobyGames** (Transport: `https/api`).
*   **Distinction**: Archive.org is a *ReferenceLibrary*. Apple is a *ReferenceManufacturer*.

### ReferenceLibraryDataStore ("The Public Cache")
*   **Definition**: The local repository where the actual data files (imported disk images, artwork, manuals) for a **ReferenceLibrary** are stored.
*   **Structure**: Uses a **Git-style directory structure** (Content-Addressable Storage).
*   **Role**: Serves as a functional **Cache** or **Mirror** of the Data Source (Source of Truth).
*   **States**:
    *   **Partial Store**: Stores only files the user has accessed.
    *   **Complete Mirror**: Stores the full set of files for the collection.
*   **Context**: Distinction between *Reference Metadata* (The List) and *Reference Data Store* (The Files).

### ReferenceManufacturer ("The Creator")
*   **Definition**: The company, individual, or entity that originally *created* or *published* the product.
*   **Previous Term**: Inventory Manufacturer.
*   **Context**: The "Brand" or "Author".
*   **Curation Level**: **Heavily Curated**. These entities are verified against **US Copyright and Trademark entries** and extracted from known good sources (e.g., **WOZ** file headers from **Archive.org** by trusted contributors like **4am**).
*   **Examples**: **Apple**, **Commodore**, **Broderbund**, **Richard Garriott**.
*   **Key Attributes**:
    *   **Identity**: `name`, `slug`, `alsoKnownAs`, `alternativeSpellings`.
    *   **Contact**: `addresses` (HQ/Offices), `email`, `images` (Logos, Office Photos).
    *   **People**: `developers` (Technical staff), `associatedPeople` (Founders, Key figures).
*   **Distinction**: Users buy products *made* by a Manufacturer, but may get the *data* from a Library.

### ReferenceManufacturerCatalog ("The Offering")
*   **Definition**: The complete set of Products offered by a specific **ReferenceManufacturer** during a specific era or generally.
*   **Context**: Represents the "Original Catalog" of the creator.
*   **Nature**: **Static Data**. Resides in the **Shared Data Space** of the application (available to all users).
*   **Curation Level**: **Heavily Curated**. Verified against **US Copyright and Trademark entries** and extracted from known good sources (e.g., **WOZ** file headers from **Archive.org** by trusted contributors like **4am**).
*   **Example**: "Apple Computer Catalog (1980-1989)", "Broderbund Software Catalog".
*   **Role**: Groups Products by their **Manufacturer**. Distinct from a *ReferenceCollection* (which is curated by a Library).

### ReferenceCollection ("The Grouping")
*   **Definition**: A curated set or grouping of Products or Assets provided by a Library.
*   **Previous Term**: Inventory Collection (Public).
*   **Context**: Used for organization and discovery.
*   **Examples**:
    *   "**TOSEC Apple II**": A comprehensive preservation project collection.
    *   "**Archive.org Software Library: Apple II**": A massive library of disk images.
    *   "**MobyGames: Best RPGs of 1990**": A metadata-only list of top-rated games.
    *   "**Retrobox Community**": The official destination for user contributions (Hosted on Archive.org).
        *   Segmented by Platform: `retrobox_apple2`, `retrobox_c64`.


### ReferenceProduct ("The Catalog Entry")
*   **Definition**: A concrete instance of an **InventoryProduct** representing an Authority Record in the Library.
*   **Nature**: **Compound Type**. Contains related files (`ReferenceItem`s) such as disk images, artwork, and manuals.
*   **Previous Term**: Compound Resource / Public Product.
*   **Conforms To**: `InventoryProduct` (Metadata) + `InventoryCompoundBase` (Structure).
*   **Role**: Acts as the official **Identity** and **Container** for the Reference Assets.
*   **Example**: "The Oregon Trail" (Entry), which contains `oregon.dsk` and `manual.pdf`.

### ReferenceItem ("The File Metadata Entry")
*   **Definition**: A concrete instance of an **InventoryItem** inside a Reference Product.
*   **Nature**: **METADATA ONLY**. Describes the file that *should* exist (Filename, Checksums, Type).
*   **Storage**: The actual file content (blob) is stored in the **ReferenceLibraryDataStore**, keyed by the `ReferenceItem.id`.
*   **Previous Term**: Public Resource.
*   **Conforms To**: `InventoryItem` (Filename, Hashes, Classifier).
*   **Context**:
    *   **Software**: The metadata for `game.dsk` (SHA-1: abc1234...).
    *   **Hardware**: The metadata for `motherboard_front.jpg`.
*   **Relationship**: The `ReferenceProduct` contains a list of these *Entries*.

### LibraryConsortium ("The Network")
*   **Definition**: The global network/collection of all known **ReferenceLibraries**.
*   **Context**: A cooperative group that pools resources to offer more than individual libraries could.
*   **Role**: Top-level container for all Reference data.

### UnionCatalog ("The Index")
*   **Definition**: The unified database or index that consolidates metadata from the **LibraryConsortium** (Reference) and the **Personal Archive** (User/Inventory).
*   **Role**: Enables deduplication, cross-referencing, and search across all resources (Global + Local).
*   **Implementation**: A local database (SQLite/SwiftData) managed by the Application.
*   **Goal**: To provide a "Single Pane of Glass" view of all Retro assets, regardless of ownership.

---

## 4. Relationships

| Entity A | Relationship | Entity B | description |
| :--- | :--- | :--- | :--- |
| **Inventory Asset** | *is an instance of* | **ReferenceProduct** | My specific unit is an instance of the general product model. |
| **Inventory Asset** | *is acquired from* | **ReferenceProduct** | My private asset was downloaded from this library item. |
| **Inventory Asset Component** | *is a copy of* | **ReferenceItem** | My local file is a copy of this library reference file. |
| **ReferenceProduct** | *is created by* | **ReferenceManufacturer** | The product was originally made by this company. |
| **ReferenceProduct** | *is described by* | **ReferenceLibrary** | The metadata for this product came from this source. |
| **ReferenceCollection**| *is provided by* | **ReferenceLibrary** | This grouping of products was curated by this source. |

---

## 5. Other Concepts

### Inventory Identifier ("The Tags")
*   **Definition**: A strongly-typed external or internal identifier attached to an **InventoryItem**.
*   **Structure**: `type` (Enum) + `value` (String).
*   **Types**:
    *   **`nfc_tag`**: Physical NFC Token ID attached to the box.
    *   **`qr_code`**: Scanned QR code content.
    *   **`barcode`**: UPC/EAN scan.
        *   **Note**: "UPC Code" was the common term during the retro era (1977-2000). In this system, `barcode` encompasses UPC, EAN, and others, but `.upc` is provided as an alias.
    *   **`library_reference_id`**: External ID from a Data Source (e.g. Archive.org identifier).
    *   **`library_id`**: The ID of the Library/Provider itself (e.g. `ia`).
    *   **`serial_number`**: Manufacturer serial.

### Inventory Resource Name (IRN)
*   **Definition**: A unique identifier string used to reference **ANY** resource within the system universally (both Public and Private).
*   **Format**: `inventory:partition:service:namespace:type:id`
*   **Examples**:
    *   **Public Product**: `inventory:public:product:global:software:123...`
    *   **Private Asset**: `inventory:private:asset:{user-id}:disk-image:456...`

### Asset Relationship Types ("The Connections")
*   **Definition**: Standardized high-level relationships between two Assets or between an Asset and a Product.
*   **Types**: `variant_of`, `derived_from`, `component_of`, `contained_in`, `requires`, `bundled_with`.

### Collection Bundle ("The Subscription")
*   **Definition**: A compressed, versioned package containing a **Public Collection** and its associated **Products**.
*   **Role**: The distribution mechanism (Public Domain).

### Draft Asset ("The Shadow Copy")
*   **Definition**: A temporary, detached copy of an Asset used specifically for **Metadata Editing** in the UI.

---

## 6. Workflows & Lifecycle

### Retroactive Matching ("Enrichment")
*   **Scenario**: User imports an Asset *before* the Public Product exists in the catalog.
*   **State**: The Asset is **Standalone** (Unlinked).
*   **Event**: A new Public Catalog bundle is released containing the Product.
*   **Action**: The system detects a match (via Hash or Filename).
*   **Result**:
    1.  The Asset's `productID` is updated to link to the new Product.
    2.  The User's Asset file is **NOT touched** (it remains their specific copy/version).
    3.  The *View* of the Asset is **Enriched** with the new Public Metadata (Cover Art, Description).

### Workbench Workflow
*   **Concept**: Preserving the Original state of an Asset while allowing modifications.
*   **Immutable Asset**: When imported, the Asset (Original/Derived) is treated as **Read-Only** (Preservation Copy).
*   **Workbench**: A workspace where users perform modify operations (Play, Crack, Hex Edit).

### ContributionRequest ("The Submission")
*   **Definition**: A structured request to promote a **Custom** entity or fix an existing **Reference** entity.
*   **Types**:
    *   **New Entry**: "Here is a game you don't have."
    *   **Correction**: "The release date for Prince of Persia is wrong." (Patch).
*   **Fields**: `targetID` (nil if new), `proposedData` (JSON), `comment` (User explanation), `submitterID`.
*   **Workflow**:
    1.  User submits form (with Comment).
    2.  System creates `ContributionRequest`.
    3.  **Admin/Curator Role**: A dedicated CloudKit Role (assigned via Dashboard) effectively sees a "Review Queue" in the app or admin tool.
    *   **Merge Process**: A trusted Curator text/json blob from the Request is merged into the authoritative `ReferenceProduct` by a user with Admin roles.
    *   **Archive.org Integration**:
        *   **Identifiers**: Must be unique, 5-80 chars, alphanumeric + `_/-`. No leading specials.
        *   **Metadata**: Uploads use S3 headers (`x-archive-meta-title: Foo`). Custom fields use `--` for underscores (`x-archive-meta-my--field: val`).
        *   **Collection Strategy**: New items upload to `community` first (or `retrobox_community`). Once 50+ items exist, we request official `retrobox_{platform}` collections.
*   **Technical Implementation (CloudKit)**:
    *   **Public Database**: `ReferenceProduct` records are **World-Readable** but **Admin-Writable** only.
    *   **Gatekeeper Pattern**: Users have "Create Permission" for `ContributionRequest` records.
    *   **Security**: The "Admin" capability is managed via **CloudKit Dashboard Roles**, ensuring only trusted accounts can write to `ReferenceProduct`.

### WorkbenchItem ("The Working Copy")
*   **Definition**: A temporary, **Mutable** wrapper containing an **InventoryCompoundBase**.
*   **Role**: Enables "Safe Modification" of an asset's content or structure without altering the original Preservation Copy.
*   **Contains**: A full copy of the `InventoryAsset` (Compound Base).
*   **Usage**: Playing a game (saving high scores writes to disk), removing copy protection, adding a manual to a folder.
*   **Result**: Can be saved back as a new **Modified Asset**, leaving the original untouched.

---

## 7. Location & Containers ("Where is it?")

### InventorySpace ("The Place")
*   **Definition**: The abstract base type for any location that can hold items or containers.
*   **Context**: Can be Physical or Digital.
*   **Conforming Types**:
    *   **`InventoryBuilding`**: Top-level physical structure (e.g. "Main House", "Warehouse").
    *   **`InventoryRoom`**: A specific area within a building (e.g. "Retro Lab", "Basement").
    *   **`InventoryVolume`**: A digital storage unit (e.g. "Macintosh HD", "Cloud Drive").

### ItemContainer ("The Box")
*   **Definition**: A concrete object that holds `InventoryItems`.
*   **Role**: Groups items together for storage and tracking.
*   **Types**:
    *   **`ItemContainerPhysical`**: A physical box, bin, or shelf. specific to a `InventoryRoom`.
    *   **`ItemContainerDigital`**: A folder or archive specific to a `InventoryVolume`.
*   **Attributes**:
    *   `identifiers`: NFC, Barcode, or QR codes used for scanning/lookup.
    *   `location`: The specific `ItemLocation` (Room + Exact Spot).

### ItemLocation ("The Address")
*   **Definition**: A unified value type describing exactly where an item or container is.
*   **Variants**:
    *   **`physical`**: Links to an `InventoryRoom`, optional `InventoryGeoLocation`, and a descriptive string (e.g. "Shelf A").
    *   **`digital`**: Links to a `InventoryVolume` and a URL path.
