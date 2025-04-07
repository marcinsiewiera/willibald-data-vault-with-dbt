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

### SQL Examples (Conceptual PostgreSQL/T-SQL)

Assume:
*   `hub_customer` (PK: `CustomerHashKey`, BK: `CustomerID`)
*   `sat_customer_details` (PK: `CustomerHashKey`, `LoadDate`, Attrs: `Name`, `Address`, `HashDiff`) - *Used for both methods*
*   `sts_customer_status` (PK: `CustomerHashKey`, `StatusLoadDate`, Attrs: `Status`) - *Method 1 Only*
*   `sat_customer_details_with_status` (PK: `CustomerHashKey`, `LoadDate`, Attrs: `Name`, `Address`, `IsDeleted`, `HashDiff`) - *Method 2 Only*
*   `pit_customer` (PK: `CustomerHashKey`, `SnapshotDate`, Columns: `LoadDate_Details`, `LoadDate_Status` [Method 1] or just `LoadDate` [Method 2], `IsDeleted` [pre-joined])

**Example 1: Retrieving Current Status and Name**

*   **Method 1 (Using STS):**

```sql
WITH LatestStatus AS (
    SELECT
        sts.CustomerHashKey,
        sts.Status,
        ROW_NUMBER() OVER(PARTITION BY sts.CustomerHashKey ORDER BY sts.StatusLoadDate DESC) as rn
    FROM sts_customer_status sts
), LatestDetails AS (
    SELECT
        scd.CustomerHashKey,
        scd.Name,
        ROW_NUMBER() OVER(PARTITION BY scd.CustomerHashKey ORDER BY scd.LoadDate DESC) as rn
    FROM sat_customer_details scd
)
SELECT
    hc.CustomerID,
    ld.Name,
    ls.Status -- Assuming 'A'/'D' or similar
FROM hub_customer hc
JOIN LatestDetails ld ON hc.CustomerHashKey = ld.CustomerHashKey AND ld.rn = 1
JOIN LatestStatus ls ON hc.CustomerHashKey = ls.CustomerHashKey AND ls.rn = 1
WHERE ls.Status = 'A'; -- Example: Get only currently 'Active' customers
```

*   **Method 2 (Using Embedded Status):**

```sql
WITH LatestRecord AS (
    SELECT
        scdws.CustomerHashKey,
        scdws.Name,
        scdws.IsDeleted, -- Assuming boolean or 0/1
        ROW_NUMBER() OVER(PARTITION BY scdws.CustomerHashKey ORDER BY scdws.LoadDate DESC) as rn
    FROM sat_customer_details_with_status scdws
)
SELECT
    hc.CustomerID,
    lr.Name,
    lr.IsDeleted
FROM hub_customer hc
JOIN LatestRecord lr ON hc.CustomerHashKey = lr.CustomerHashKey AND lr.rn = 1
WHERE lr.IsDeleted = false; -- Example: Get only currently non-deleted customers
```

**Example 2: Retrieving Status from a Point-In-Time (PIT) Table**

Assume a PIT table `pit_customer` is built nightly, capturing the correct satellite `LoadDate` pointers for each `CustomerHashKey` as of the `SnapshotDate`. The PIT structure slightly differs depending on the chosen method.

*   **Method 1 (PIT referencing STS and Descriptive Sat):**
    *   `pit_customer` columns might include: `CustomerHashKey`, `SnapshotDate`, `LoadDate_Details`, `LoadDate_Status`.

```sql
-- Get Name and Status as of '2023-05-15'
SELECT
    hc.CustomerID,
    scd.Name,
    sts.Status
FROM pit_customer pit
JOIN hub_customer hc ON pit.CustomerHashKey = hc.CustomerHashKey
JOIN sat_customer_details scd
    ON pit.CustomerHashKey = scd.CustomerHashKey
    AND pit.LoadDate_Details = scd.LoadDate -- Join using the specific LoadDate from PIT
JOIN sts_customer_status sts
    ON pit.CustomerHashKey = sts.CustomerHashKey
    AND pit.LoadDate_Status = sts.StatusLoadDate -- Join using the specific StatusLoadDate from PIT
WHERE
    pit.SnapshotDate = '2023-05-15' -- The date the PIT was built for
    -- AND sts.Status = 'A' -- Optional: Filter further by status at that time
;
```

*   **Method 2 (PIT referencing Descriptive Sat with Status):**
    *   `pit_customer` columns might include: `CustomerHashKey`, `SnapshotDate`, `LoadDate`. The status is retrieved from the single referenced satellite record.

```sql
-- Get Name and Status as of '2023-05-15'
SELECT
    hc.CustomerID,
    scdws.Name,
    scdws.IsDeleted
FROM pit_customer pit
JOIN hub_customer hc ON pit.CustomerHashKey = hc.CustomerHashKey
JOIN sat_customer_details_with_status scdws
    ON pit.CustomerHashKey = scdws.CustomerHashKey
    AND pit.LoadDate = scdws.LoadDate -- Join using the single LoadDate pointer from PIT
WHERE
    pit.SnapshotDate = '2023-05-15' -- The date the PIT was built for
    -- AND scdws.IsDeleted = false -- Optional: Filter further by status at that time
;

```
