## Status Tracking in Data Vault 2.0: STS vs. Embedded Attribute

Tracking the lifecycle of a business key, especially deletions or status changes, is crucial for maintaining data integrity and providing accurate historical context. In Data Vault 2.0, two primary methods emerge for handling this: dedicated Status Tracking Satellites (STS) and embedding a status attribute within descriptive satellites.

### 1. Dedicated Status Tracking Satellites (STS)

**Structure:**
An STS is a specific type of satellite linked directly to a Hub (or sometimes a Link). Its primary purpose is to track changes in the *status* of the business key represented by the Hub.

*   **Primary Key:** `Hub/Link HashKey`, `StatusLoadDate`
*   **Attributes:**
    *   `Hub/Link HashKey`: Foreign key referencing the parent Hub/Link.
    *   `StatusLoadDate`: Timestamp indicating when this status became effective (often the `LoadDate` from the source or staging).
    *   `StatusIndicator`: A flag or code representing the status (e.g., 'A'/'D', 'Active'/'Deleted', 1/0).
    *   `RecordSource`: Source system identifier.

**Pros:**

*   **Clear Separation of Concerns:** Strictly adheres to DV2 principles by isolating status changes from descriptive attribute changes. Descriptive satellites track *what* changed, while the STS tracks *if* the key's active status changed.
*   **Historical Accuracy (Status):** Provides a clean, independent timeline of status changes. Querying the history of *only* the status is straightforward.
*   **Storage Efficiency (Potentially):** If status changes are infrequent compared to descriptive attribute changes, the STS will contain fewer records than embedding the status in a descriptive satellite, saving storage.
*   **Simpler Loading Logic (for Status):** The loading logic focuses solely on detecting status changes (e.g., record appearance/disappearance in the source feed compared to the Hub).

**Cons:**

*   **Increased Table Count:** Introduces additional satellite tables to the model.
*   **Query Complexity (Combined View):** Retrieving the *current* descriptive attributes *and* the *current* status requires joining the Hub, the latest record from the descriptive satellite, *and* the latest record from the STS.
*   **Potentially Complex Loading (Overall):** While STS loading itself is simple, coordinating it with descriptive satellite loading might require careful orchestration, especially if status information isn't explicitly provided by the source and needs to be derived (e.g., by detecting missing keys).

### 2. Status Attribute in Descriptive Satellites

**Structure:**
This method involves adding a status column directly into one or more descriptive satellites associated with a Hub/Link.

*   **Primary Key:** `Hub/Link HashKey`, `LoadDate`
*   **Attributes:**
    *   `Hub/Link HashKey`: Foreign key referencing the parent Hub/Link.
    *   `LoadDate`: Timestamp indicating when this version of the record (including descriptive attributes *and* status) became effective.
    *   *Descriptive Attributes...*: Various attributes describing the business key.
    *   `RecordStatus` / `IsDeleted` / etc.: The status indicator.
    *   `RecordSource`: Source system identifier.
    *   `HashDiff`: Typically present to detect changes in descriptive attributes. *Crucially, the status attribute itself should generally NOT be part of the HashDiff calculation if you want to track descriptive changes independently*.

**Pros:**

*   **Fewer Tables:** Reduces the number of objects in the Raw Vault.
*   **Simpler Queries (Current View):** Retrieving the current descriptive attributes and status involves joining the Hub only to the latest record of the relevant descriptive satellite.
*   **Potentially Simpler Loading (Combined Source):** If the source system provides descriptive attributes and status information together in the same feed, loading them into a single satellite can be more straightforward.

**Cons:**

*   **Mixing Concerns:** Violates the strict separation of concerns principle. The satellite now tracks both descriptive changes and status changes.
*   **Data Redundancy / Storage Inefficiency:** If descriptive attributes change but the status remains the same (or vice-versa), a new satellite record is created containing the *unchanged* status (or descriptive attributes). This can lead to significant redundancy if one changes much more frequently than the other. A common scenario is loading `IsDeleted = false` repeatedly for active records whenever any other attribute changes.
*   **Historical Query Complexity (Status):** Isolating the pure history of *status* changes requires filtering the descriptive satellite and potentially ignoring records where only descriptive attributes changed. This can be less efficient than querying a dedicated STS.
*   **Ambiguity in `LoadDate`:** The `LoadDate` now signifies the effective date for the *entire row* (descriptive attributes + status). It's harder to pinpoint the exact moment a status *alone* changed if descriptive attributes changed simultaneously or more frequently.
*   **Potential Query Performance Issues:** Filtering large satellites by the status attribute (e.g., finding all currently active customers) can be slow without proper indexing.

### Optimization Consideration: Indexing Status in Descriptive Satellites

The potential performance drawback of querying the status attribute in large descriptive satellites (Method 2) can often be mitigated through indexing.

*   **Feasibility:** It is entirely feasible to include the status attribute in a non-clustered index.
*   **Impact:** Adding the status column (e.g., `IsDeleted`) to the standard satellite index on (`Hub/Link HashKey`, `LoadDate`) can significantly improve query performance.
    *   **Option 1 (Part of Key):** Index on (`HashKey`, `LoadDate`, `IsDeleted`). Less ideal as it makes the index wider and might not be optimal if `LoadDate` slicing is the primary access pattern.
    *   **Option 2 (Included Column):** Index on (`HashKey`, `LoadDate`) `INCLUDE (IsDeleted)`. This is often the preferred approach. It allows the database to satisfy queries filtering by `HashKey` and seeking the latest `LoadDate` while also efficiently checking or returning the `IsDeleted` status directly from the index pages, avoiding a further lookup to the base table data.
*   **Mitigation:** This indexing strategy *effectively mitigates* the query performance drawback for common access patterns (like finding the current status or filtering by status). However, it does *not* address the fundamental issues of mixed concerns, data redundancy, or the potential ambiguity in historical status tracking inherent in Method 2.

### Summary Comparison Table

| Feature                   | Dedicated STS (Method 1)                                  | Embedded Status (Method 2)                                       |
| :------------------------ | :-------------------------------------------------------- | :--------------------------------------------------------------- |
| **Structure**             | Separate Satellite (`HashKey`, `StatusLoadDate`, `Status`) | Status column within Descriptive Sat (`HashKey`, `LoadDate`, ..., `Status`) |
| **DV2 Principles**        | **Pro:** Strong adherence (Separation of Concerns)        | **Con:** Mixes concerns (Status + Description)                   |
| **Loading Complexity**    | **Con:** Potentially more complex orchestration           | **Pro:** Simpler if status & description sourced together        |
| **Storage Efficiency**    | **Pro:** Efficient if status changes infrequently         | **Con:** Redundant status entries if description changes often   |
| **Query Perf (Current)**  | **Con:** Requires extra join (Hub -> Desc Sat -> STS)     | **Pro:** Simpler join (Hub -> Desc Sat)                          |
| **Query Perf (History)**  | **Pro:** Direct, efficient status history query           | **Con:** Requires filtering large table; less direct             |
| **Historical Accuracy**   | **Pro:** Clear, unambiguous status change timeline        | **Con:** `LoadDate` reflects row change, not necessarily status change |
| **Table Count**           | **Con:** More tables                                      | **Pro:** Fewer tables                                            |
| **Optimization Required** | Less critical for basic status queries                    | **Yes:** Indexing on status highly recommended for performance     |

### SQL Examples (Conceptual PostgreSQL/T-SQL) - Updated for Multiple Sources

Assume:
*   Hub: `customer_h` (PK: `CUSTOMER_HK`, BK: `CUSTOMER_ID`)
*   Source `ws` Satellites:
    *   Descriptive: `customer_ws_s` (PK: `CUSTOMER_HK`, `LOAD_DATE`, Attrs: `NAME`, `ADDRESS`, `HASHDIFF`)
    *   Status (Method 1): `customer_ws_sts` (PK: `CUSTOMER_HK`, `STATUS_LOAD_DATE`, Attrs: `STATUS`)
*   Source `rs` Satellites (Same Attributes):
    *   Descriptive: `customer_rs_s` (PK: `CUSTOMER_HK`, `LOAD_DATE`, Attrs: `NAME`, `ADDRESS`, `HASHDIFF`)
    *   Status (Method 1): `customer_rs_sts` (PK: `CUSTOMER_HK`, `STATUS_LOAD_DATE`, Attrs: `STATUS`)
*   Illustrative Satellites for Method 2:
    *   `sat_customer_details_with_status_ws` (PK: `CustomerHashKey`, `LoadDate`, Attrs: `Name`, `Address`, `IsDeleted`, `HashDiff`)
    *   `sat_customer_details_with_status_rs` (PK: `CustomerHashKey`, `LoadDate`, Attrs: `Name`, `Address`, `IsDeleted`, `HashDiff`)
*   Snapshot View (built on `customer_snp` PIT): `customer_sns` (Contains pre-joined data from Hub and all relevant source satellites valid as of `SNAPSHOT_DATE`)

**Example 1: Retrieving Current Status and Attributes (Multi-Source)**

*   **Method 1 (Using Real STS Examples - `customer_ws_sts` & `customer_rs_sts`):**
    *   Logic: Get latest status and attributes from each source independently, then combine using `COALESCE`.
    *   Preference: `ws` source takes precedence over `rs` source when both are available.

```sql
WITH LatestStatusWS AS (
    -- Latest status from WS source
    SELECT
        sts.CUSTOMER_HK,
        sts.STATUS as STATUS_WS,
        ROW_NUMBER() OVER(PARTITION BY sts.CUSTOMER_HK ORDER BY sts.STATUS_LOAD_DATE DESC) as rn
    FROM customer_ws_sts sts
),
LatestStatusRS AS (
    -- Latest status from RS source
    SELECT
        sts.CUSTOMER_HK,
        sts.STATUS as STATUS_RS,
        ROW_NUMBER() OVER(PARTITION BY sts.CUSTOMER_HK ORDER BY sts.STATUS_LOAD_DATE DESC) as rn
    FROM customer_rs_sts sts
),
LatestDetailsWS AS (
    -- Latest descriptive details from WS source
    SELECT
        scd.CUSTOMER_HK,
        scd.NAME as NAME_WS,
        scd.ADDRESS as ADDRESS_WS,
        ROW_NUMBER() OVER(PARTITION BY scd.CUSTOMER_HK ORDER BY scd.LOAD_DATE DESC) as rn
    FROM customer_ws_s scd
),
LatestDetailsRS AS (
    -- Latest descriptive details from RS source
    SELECT
        scd.CUSTOMER_HK,
        scd.NAME as NAME_RS,
        scd.ADDRESS as ADDRESS_RS,
        ROW_NUMBER() OVER(PARTITION BY scd.CUSTOMER_HK ORDER BY scd.LOAD_DATE DESC) as rn
    FROM customer_rs_s scd
)
-- Final Select combining latest attributes and status with source precedence
SELECT
    hc.CUSTOMER_ID,
    -- Coalesce descriptive attributes (WS takes precedence)
    COALESCE(ws.NAME_WS, rs.NAME_RS) as NAME,
    COALESCE(ws.ADDRESS_WS, rs.ADDRESS_RS) as ADDRESS,
    -- Coalesce status (WS takes precedence)
    COALESCE(sws.STATUS_WS, srs.STATUS_RS) as STATUS
FROM customer_h hc
LEFT JOIN LatestDetailsWS ws ON hc.CUSTOMER_HK = ws.CUSTOMER_HK AND ws.rn = 1
LEFT JOIN LatestDetailsRS rs ON hc.CUSTOMER_HK = rs.CUSTOMER_HK AND rs.rn = 1
LEFT JOIN LatestStatusWS sws ON hc.CUSTOMER_HK = sws.CUSTOMER_HK AND sws.rn = 1
LEFT JOIN LatestStatusRS srs ON hc.CUSTOMER_HK = srs.CUSTOMER_HK AND srs.rn = 1
WHERE
    -- Example: Get only customers whose coalesced status is 'Active'
    COALESCE(sws.STATUS_WS, srs.STATUS_RS) = 'A';
```

*   **Method 2 (Illustrative Example - Using Embedded Status - Multi-Source):**
    *   Logic: Get latest record from each source's illustrative satellite, then combine using `COALESCE`.
    *   Preference: `ws` source takes precedence over `rs` source when both are available.

```sql
-- Note: This example uses illustrative table/column names.
WITH LatestRecordWS AS (
    SELECT
        scdws.CustomerHashKey,
        scdws.Name as Name_WS,
        scdws.Address as Address_WS,
        scdws.IsDeleted as IsDeleted_WS,
        ROW_NUMBER() OVER(PARTITION BY scdws.CustomerHashKey ORDER BY scdws.LoadDate DESC) as rn
    FROM sat_customer_details_with_status_ws scdws -- Illustrative WS table
),
LatestRecordRS AS (
    SELECT
        scdrs.CustomerHashKey,
        scdrs.Name as Name_RS,
        scdrs.Address as Address_RS,
        scdrs.IsDeleted as IsDeleted_RS,
        ROW_NUMBER() OVER(PARTITION BY scdrs.CustomerHashKey ORDER BY scdrs.LoadDate DESC) as rn
    FROM sat_customer_details_with_status_rs scdrs -- Illustrative RS table
)
SELECT
    hc.CUSTOMER_ID, -- From the real hub
    -- Coalesce descriptive attributes (WS takes precedence)
    COALESCE(ws.Name_WS, rs.Name_RS) as Name,
    COALESCE(ws.Address_WS, rs.Address_RS) as Address,
    -- Coalesce deletion status (deleted if either source indicates deletion)
    COALESCE(ws.IsDeleted_WS, rs.IsDeleted_RS, false) as IsDeleted
FROM customer_h hc -- Real hub
LEFT JOIN LatestRecordWS ws ON hc.CUSTOMER_HK = ws.CustomerHashKey AND ws.rn = 1
LEFT JOIN LatestRecordRS rs ON hc.CUSTOMER_HK = rs.CustomerHashKey AND rs.rn = 1
WHERE
    -- Example: Get only non-deleted customers based on coalesced status
    COALESCE(ws.IsDeleted_WS, rs.IsDeleted_RS, false) = false;
```

**Example 2: Retrieving Status from a Point-In-Time (PIT) / Snapshot View (Multi-Source)**

Assume the PIT (`customer_snp`) and Snapshot View (`customer_sns`) incorporate data from both source satellites (`ws` and `rs`). The view resolves the combined status and attributes using the same `COALESCE` logic as above, but as of the `SNAPSHOT_DATE`.

*   **Method 1 (Querying the Real Snapshot View `customer_sns` - Multi-Source):**
    *   The `customer_sns` view now includes coalesced columns from both sources, with `ws` taking precedence over `rs`.

```sql
-- Get coalesced Name, Address, and Status as of '2023-05-15' using the Snapshot View
SELECT
    sns.CUSTOMER_ID,     -- Directly from the view
    sns.NAME,            -- Coalesced from both sources (ws preferred)
    sns.ADDRESS,         -- Coalesced from both sources (ws preferred)
    sns.STATUS           -- Coalesced from both sources (ws preferred)
FROM customer_sns sns
WHERE
    sns.SNAPSHOT_DATE = '2023-05-15' -- Filter the view by snapshot date
    -- AND sns.STATUS = 'A' -- Optional: Filter further by status at that time
;
```

*   **Method 2 (Querying an Illustrative Snapshot View based on Embedded Status - Multi-Source):**
    *   The illustrative view (`customer_sns_method2_illustrative`) would be built incorporating data from both illustrative satellites, using `COALESCE` for attributes and status.

```sql
-- Note: This example queries an illustrative snapshot view
-- reflecting multiple sources with embedded status.
-- Get coalesced Name, Address, and Deletion Status as of '2023-05-15'
SELECT
    sns.CUSTOMER_ID,       -- From illustrative view
    sns.Name,              -- Coalesced from both sources (ws preferred)
    sns.Address,           -- Coalesced from both sources (ws preferred)
    sns.IsDeleted          -- Coalesced from both sources (deleted if either indicates)
FROM customer_sns_method2_illustrative sns -- Querying the illustrative view
WHERE
    sns.SNAPSHOT_DATE = '2023-05-15' -- Filter the view by snapshot date
    -- AND sns.IsDeleted = false -- Optional: Filter further by status at that time
;

```
