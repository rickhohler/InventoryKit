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
*   **Key Attributes**: `manufacturer`, `releaseDate`, `sku`, `title`.
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
    *   **Classification**: `typeClassifier` (Media, Art, Doc, Hardware).
    *   **Identifiers**: `identifiers: [InventoryIdentifier]` (NFC, QR Code, Barcode, Public Library ID).
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
    *   **Custody**: Storage location (managed via `ItemLocation` / `ItemContainer`).
    *   **Provenance**: History of *this specific instance* (e.g., "Bought 1983").
    *   **Condition**: Physical/Digital state (e.g. "Mint", "Corrupted").
    *   **Ownership Status**: "Owned" vs "Possessed" vs "Wishlist".
*   **Children**: Contains `InventoryAssetComponents` (which conform to `InventoryItem`).
*   **Example**: "Ultima IV Box (Container)" -> contains -> "Game Disk (Media)", "Cloth Map (Artwork)", "Manual (Document)".

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

---

## 3. Public Domain Entities (Library)

### Library ("Public Library")
*   **Definition**: The universe of shared knowledge and public information available to the **Library Consortium**.
*   **Context**: Contains **Products** and **Public Collections**.
*   **Role**: Serves as the global "Reference Material" for the system.
*   **Attributes**:
    *   **`library_id`**: A small, unique identifier for the library instance (e.g., `ia` for Archive.org, `mg` for MobyGames).

### Compound Resource ("The Library Item")
*   **Definition**: A concrete instance of an **InventoryCompoundBase** inside the Library.
*   **Conforms To**: `InventoryCompoundBase` (Title, Metadata, Children).
*   **Context**: Archive.org calls this an "Item".
*   **Structure**: Contains one or more **Public Resources**.
*   **Role**: Serves as the source package for an **Inventory Product**.
*   **Example**: The "Prince of Persia" item on Archive.org, which contains `prince.dsk`, `manual.pdf`, and `cover.jpg`.

### Public Resource ("The File/Part")
*   **Definition**: A concrete instance of an **InventoryItem** inside a Library Item.
*   **Conforms To**: `InventoryItem` (Filename, Hashes, Classifier).
*   **Context**:
    *   **Software**: The `game.dsk` file.
    *   **Hardware**: The `motherboard_photo_front.jpg` file.
*   **Relationship**: When a user downloads a *Public Resource*, it becomes a *User Asset Component*.

### Inventory Manufacturer ("The Creator")
*   **Definition**: The company, individual, or entity that originally *created* or *published* the product.
*   **Context**: The "Brand" or "Author".
*   **Examples**: **Apple**, **Commodore**, **Broderbund**, **Richard Garriott**.
*   **Distinction**: Users buy products *made* by a Manufacturer, but may get the *data* from a Data Source.

### Inventory Collection ("The Grouping")
*   **Definition**: A curated set or grouping of Products or Assets.
*   **Context**: Used for organization and discovery. Includes both **Public** and **Personal** collections.
*   **Types**:
    *   **Public Collection (Shared)**: Provided by a Data Source.
        *   *Content*: References **Public Products**.
        *   *Visibility*: Visible to everyone using that Data Source.
    *   **Personal Collection (Private)**: Created by the User.
        *   *Content*: References **User Assets** (or links to Products).
        *   *Visibility*: Visible only to the user (Private Realm).
*   **Examples**:
    *   **Public (Curated)**:
        *   "**TOSEC Apple II**": A comprehensive preservation project collection.
        *   "**Archive.org Software Library: Apple II**": A massive library of disk images.
        *   "**MobyGames: Best RPGs of 1990**": A metadata-only list of top-rated games.
    *   **Personal (User)**:
        *   "**My Childhood Games**": A user-created list of assets they owned as a kid.
        *   "**Restoration Queue**": A list of hardware assets currently being repaired.
        *   "**Favorites**": A simple playlist-style collection of assets.
*   **Membership**: **Many-to-Many**. A single Product or Asset can belong to **multiple collections** simultaneously (e.g., "Lode Runner" is in "Apple II Games" AND "Top Platformers").

### Collection Category ("The Nature of the Group")
*   **Definition**: Describes the *intent* or *mechanism* of the grouping.
*   **Categories**:
    *   **`curated_set`**: A statically defined list by an authority (e.g. "Best RPGs of 1990").
    *   **`playlist`**: An arbitrary, user-ordered list (e.g. "To Play Next").
    *   **`series`**: A sequential grouping of related creative works (e.g. "Ultima I, II, III...").
    *   **`smart_rule`**: A dynamic collection defined by a query/predicate (e.g. "All items where Manufacturer == Apple").

### Inventory Data Source ("The Provider")
*   **Definition**: The entity or organization that *provides* the catalog data, metadata, or curated collections.
*   **Context Replaces**: Often referred to as "Vendor" in previous designs, but renamed to avoid confusion with "Manufacturer".
*   **Key Attributes**:
    *   **Reliability**: Is this a trusted source? (e.g., Verified).
    *   **Type**: Archive, Museum, Database, Community.
    *   **Transport**: The protocol used to fetch data (`https`, `ssh`, `ftp`, `s3`).
    *   **Source Adapter**: The specific logic module that handles connection, auth, and converts the Provider's specific schema into the app's `InventoryCompoundBase` / `InventoryItem` world.
*   **Example**: **Archive.org** (Transport: `https`, Adapter: `ArchiveOrgAdapter`), **MobyGames** (Transport: `https/api`, Adapter: `MobyGamesAdapter`).
*   **Distinction**: Archive.org is a *Data Source*. Apple is a *Manufacturer*.

### Library Consortium
*   **Definition**: A consortium of libraries is simply called a library consortium, a cooperative group that pools resources (like e-resources, staff, technology) to offer more than individual libraries could, benefiting users through shared collections, cost savings (especially for digital licenses), and coordinated services, often formed across local, state, or even international boundaries for academic, public, or school libraries.
*   **Context**: In our context, we have a library consortium of all public domain (library) disk images, artwork, pdfs, and other retro related artifacts/files.

### Manufacturer Catalog ("The Manufacturer's Offerings")
*   **Definition**: The complete set of Products offered by a specific Manufacturer during a specific era or generally.
*   **Context**: Represents the "Original Catalog" of the creator.
*   **Example**: "Apple Computer Catalog (1980-1989)", "Broderbund Software Catalog".
*   **Role**: Groups Products by their **Manufacturer**. Distinct from a *Collection* (which is curated by a Data Source).

### Library Data Store ("The Public Cache")
*   **Definition**: The local repository where the actual data files (imported disk images, artwork, manuals) for a **Library** resource are stored.
*   **Structure**: Uses a **Git-style directory structure** (Content-Addressable Storage).
*   **Role**: Serves as a functional **Cache** or **Mirror** of the Data Source (Source of Truth).
*   **States**:
*   **Partial Store**: Stores only files the user has accessed.
*   **Complete Mirror**: Stores the full set of files for the collection.
*   **Context**: Distinction between *Library Metadata* (The List) and *Library Data Store* (The Files).

### Union Catalog ("The Index")
*   **Definition**: The unified database or index that consolidates metadata from the **Library Consortium** (Public) and the **Personal Archive** (Private).
*   **Role**: Enables deduplication, cross-referencing, and search across all resources (Global + Local).
*   **Implementation**: A local database (SQLite/SwiftData) managed by the Application.
*   **Goal**: To provide a "Single Pane of Glass" view of all Retro assets, regardless of ownership.

---

## 4. Relationships

| Entity A | Relationship | Entity B | description |
| :--- | :--- | :--- | :--- |
| **Inventory Asset** | *is an instance of* | **Inventory Product** | My specific unit is an instance of the general product model. |
| **Inventory Asset** | *is acquired from* | **Compound Resource** | My private asset was downloaded from this public library item. |
| **Inventory Asset Component** | *is a copy of* | **Public Resource** | My local file is a copy of this public library file. |
| **Inventory Product** | *is created by* | **Manufacturer** | The product was originally made by this company. |
| **Inventory Product** | *is described by* | **Inventory Data Source** | The metadata for this product came from this source. |
| **Inventory Collection**| *is provided by* | **Inventory Data Source** | This grouping of products was curated by this source. |

---

## 5. Other Concepts

### Inventory Identifier ("The Tags")
*   **Definition**: A strongly-typed external or internal identifier attached to an **InventoryItem**.
*   **Structure**: `type` (Enum) + `value` (String).
*   **Types**:
    *   **`nfc_tag`**: Physical NFC Token ID attached to the box.
    *   **`qr_code`**: Scanned QR code content.
    *   **`barcode`**: UPC/EAN scan.
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
