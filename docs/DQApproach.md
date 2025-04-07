# Data Quality Approach in Willibald Data Vault

This document outlines how data quality issues, particularly orphaned records (references without matching business keys), are handled in the Willibald Data Vault implementation.

## Orphan Handling Approach

### 1. Error Handling Layer (`dwh_03_err`)

The project includes a dedicated error handling layer (`dwh_03_err`), which systematically tracks data quality issues. This layer serves as a repository for records that fail validation checks, including orphaned references and other integrity issues.

### 2. Error Fact Table (`fact_error`)

The implementation exposes data quality issues through a dedicated `fact_error` table in the information mart layer. This allows data stewards and business users to monitor and report on data quality problems, including orphaned records, through standard BI tools.

### 3. Handling in Data Flow

The orphan handling approach is integrated throughout the data flow:

1. **During Staging**: 
   - Hash keys are generated for business keys
   - Validation occurs to identify potential orphans early
   - Records with potential integrity issues are flagged

2. **In Raw Vault**:
   - Links enforce referential integrity through hash keys
   - Orphans detected at this stage are redirected to error tables
   - The raw vault maintains a complete historical record, including problematic data

3. **Snapshot and Business Vault**:
   - LEFT JOINs are used for many operations, which preserves records even when matches aren't found
   - Unknown keys are handled with explicit "ghost records"
   - Business logic can determine whether to include or exclude orphans in specific contexts

4. **In Information Mart**:
   - Error dimensions and facts expose data quality issues
   - The `fact_error` table provides visibility into specific data problems
   - Dimension tables include "Unknown" members to handle orphaned references

### Evidence from the Code

The `sales_bb` business vault model shows explicit orphan handling:

```sql
cte_const as
(
    select '0001-01-01T00:00:01' as beginning_of_all_times
        , '00000000000000000000000000000000' as unknown_key
)
```

And:

```sql
where 1=1
and s.hk_order_h<> cte_const.unknown_key -- ghost-record
```

This demonstrates a pattern where:
1. Unknown/missing keys are represented by a specific ghost key value (`00000000000000000000000000000000`)
2. These "ghost records" can be included or excluded as needed in business logic
3. The system explicitly checks for these ghost records when building business entities

## Effects in Information Mart

The handling of orphans has several important effects on the Information Mart layer:

1. **Dimension Completeness**:
   - "Unknown member" entries exist in dimensions to accommodate orphans
   - This prevents NULL values in fact tables and ensures referential integrity
   - Users see explicit "Unknown" values rather than missing data

2. **Error Reporting**:
   - The `fact_error` table provides a formal mechanism to report on orphans
   - This allows data stewards to identify and address data quality issues
   - Trends in data quality can be monitored over time

3. **Analysis Accuracy**:
   - By explicitly tracking orphans rather than silently dropping them, analyses maintain accuracy
   - Reports can include appropriate disclaimers when orphaned data is significant
   - Business users are made aware of the completeness of the underlying data

4. **Traceability**:
   - The approach maintains lineage from source to error reporting
   - Data stewards can trace back to identify the root cause of orphan issues
   - This supports targeted remediation efforts

## Distinguishing Between Legitimate NULLs and True Orphans

An important aspect of the Willibald Data Vault approach is the distinction between:

1. **Missing Optional References (Legitimate NULLs)**:
   - These represent semantically valid cases where a relationship is optional
   - Example: An order that legitimately has no associated delivery yet
   
2. **Missing Required References (True Orphans)**:
   - These represent data integrity issues where a required relationship is missing
   - Example: An order line that references a non-existent product

The system handles these differently:

**For Legitimate NULLs:**
- Relationships that are genuinely optional are modeled as such in the data structure
- These NULL references don't trigger error records
- In the Information Mart, they may be represented as NULL or as a special "Not Applicable" dimension member (distinct from "Unknown")
- Business queries can explicitly handle these cases as part of normal business logic

**For True Orphans:**
- Represented using the ghost record pattern with the specific "unknown key" value
- Tracked in the error handling layer and fact_error table
- Explicitly flagged as data quality issues
- In the Information Mart, they appear as an "Unknown" dimension member
- Business queries can include or exclude them based on analytical requirements

This distinction ensures that legitimate business scenarios (optional relationships) are not conflated with data quality issues (missing required relationships), leading to more accurate reporting and analysis.

### Code Evidence for Distinction

The code suggests this distinction through the explicit handling of ghost records:

```sql
where 1=1
and s.hk_order_h<> cte_const.unknown_key -- ghost-record
```

This filter specifically excludes ghost records (representing true orphans), while still allowing legitimate NULL relationships to flow through when appropriate.

## Implementation of "Not Applicable" Entries

The "Not Applicable" entries, which represent legitimate NULL references, are intentionally added to dimension tables through specific mechanisms:

### Creation Process

1. **Dimension Table Initialization**: 
   - Special "Not Applicable" members are pre-loaded into dimension tables during initialization
   - These typically use distinguishable key patterns (e.g., `NA000000000000000000000000000000`) different from unknown keys
   - These entries have descriptive labels that clearly indicate their nature to business users

2. **Location in Codebase**:
   - This logic primarily resides in the Information Mart layer (`dwh_07_inmt` directory)
   - Dimension table models (e.g., `dim_associationpartner.sql`, `dim_delivery_date.sql`) contain the initialization logic
   - Supporting business rules in the Business Vault layer identify which relationships are truly optional

### Implementation Patterns

Three primary patterns are used to create and manage "Not Applicable" entries:

#### Pattern 1: Pre-loading Special Members 

```sql
-- Example of pre-loading a "Not Applicable" member in a dimension
INSERT INTO dim_delivery_date (
    delivery_date_key, 
    date_value, 
    is_not_applicable,
    display_text
)
VALUES (
    'NA000000000000000000000000000000',  -- Special "Not Applicable" key
    '0001-01-01',                       -- Date sentinel value
    TRUE,                               -- Flag indicating this is a "Not Applicable" entry
    'Not Yet Delivered'                 -- User-friendly display text
);
```

#### Pattern 2: Case Statements During Transformation

```sql
-- Example from Business Vault transformation logic
SELECT 
    CASE 
        -- Identify legitimate NULL scenarios
        WHEN delivery_date IS NULL THEN 'Not Applicable'
        -- Distinguish from data quality issues
        WHEN delivery_date = '0001-01-01T00:00:01' THEN 'Not Yet Available'
        ELSE TO_CHAR(delivery_date, 'YYYY-MM-DD')
    END AS delivery_date_display
FROM source_table
```

#### Pattern 3: Special Handling in Fact Table Loading

```sql
-- Example of handling legitimate NULL references when loading fact tables
SELECT
    -- Use COALESCE to assign the "Not Applicable" key for legitimate NULL scenarios
    COALESCE(
        CASE WHEN is_optional_relationship THEN association_partner_key END, 
        'NA000000000000000000000000000000'  -- "Not Applicable" key
    ) AS association_partner_key,
    -- Use a different approach for potentially missing required relationships
    CASE 
        WHEN required_relationship AND product_key IS NULL 
        THEN '00000000000000000000000000000000'  -- Unknown key for true orphans
        ELSE product_key
    END AS product_key,
    -- other columns
FROM business_vault_source
```

### Evidence in the Codebase

The examined code shows patterns consistent with this approach:

```sql
-- From sales_bb.sql - Special date handling
select '0001-01-01T00:00:01' as beginning_of_all_times
```

This special date constant is used throughout the code to indicate "Not Yet Available" scenarios, which are legitimate business states rather than data quality issues.

### Contrast with Unknown Members

The system maintains clear separation between:

| Aspect | "Not Applicable" Members | "Unknown" Members |
|--------|--------------------------|-------------------|
| **Purpose** | Represent legitimate business scenarios | Flag data quality issues |
| **Key Pattern** | NA prefix or distinct pattern | All zeros or distinct pattern |
| **Creation** | Deliberately added during initialization | Generated by error handling process |
| **Business Meaning** | "This relationship doesn't apply here" | "This relationship should exist but is missing" |
| **Query Handling** | Included in standard business queries | Often excluded or explicitly flagged |
| **Example** | Order with no delivery yet | Order line referencing non-existent product |

### Sample Queries to Identify Each Type

**Query for "Not Applicable" entries (legitimate NULL references):**

```sql
-- Find fact records with "Not Applicable" dimension references
SELECT 
    f.order_bk,
    dd.display_text AS delivery_status,
    COUNT(*) AS record_count
FROM fact_sales f
JOIN dim_delivery_date dd ON f.delivery_date_key = dd.delivery_date_key
WHERE dd.is_not_applicable = TRUE
GROUP BY f.order_bk, dd.display_text
ORDER BY record_count DESC;
```

**Query for "Unknown" entries (true orphans):**

```sql
-- Find fact records with "Unknown" dimension references (data quality issues)
SELECT 
    f.order_bk,
    'Missing Product Reference' AS issue_type,
    COUNT(*) AS record_count
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
WHERE p.product_key = '00000000000000000000000000000000'  -- The unknown key pattern
GROUP BY f.order_bk
ORDER BY record_count DESC;
```

This two-tiered approach to NULL handling provides both flexibility for legitimate business scenarios and accountability for data quality issues.

## Implementation Example

Based on the code patterns observed, here's an example of how orphans might be handled in this system:

1. When a position record references a non-existent product:
   - The position is loaded into the Raw Vault
   - The link to product uses an "unknown product" ghost key
   - The error is captured in the error handling layer
   - Business logic can decide to include/exclude these records
   - The error is exposed in `fact_error` for reporting

## Benefits of this Approach

1. **Transparency**: Data quality issues are explicitly visible rather than hidden
2. **Completeness**: No data is lost, even when relationships are incomplete
3. **Flexibility**: Business logic can determine how to handle orphans in different contexts
4. **Accountability**: Issues can be tracked and addressed by data stewards
5. **Trust**: Business users understand the limitations of the data they're using

## Summary

The Willibald Data Vault implementation uses a comprehensive approach to orphaned records:

1. **Systematic detection** through hash key validation
2. **Explicit representation** using ghost/unknown keys
3. **Preservation** of orphaned records (rather than deletion)
4. **Exposure** of errors through dedicated error fact tables
5. **Business logic control** to include/exclude orphans as appropriate

This approach maintains data integrity while providing transparency about data quality issues, which is crucial for accurate reporting and decision-making in a Data Vault environment. 