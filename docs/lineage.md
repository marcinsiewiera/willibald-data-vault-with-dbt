# Data Lineage Documentation for Willibald Data Vault with dbt

This document outlines the data flow through the Willibald Data Vault implementation, from source systems to final information marts.

## Overview of Data Architecture

The Willibald Data Vault implementation follows a layered approach with the following components:

1. **Source Systems**:
   - Webshop (`webshop_*`)
   - Roadshow (`roadshow_*`)
   - Miscellaneous (`misc_*`)

2. **Loading Layer** (`dwh_02_load`):
   - Extracts data from source systems
   - Performs minimal transformations for loading

3. **Staging Layer** (`dwh_03_stage`):
   - Standardizes and validates source data
   - Calculates hash keys for Data Vault entities
   - Prepares data for loading into the Raw Vault

4. **Raw Vault** (`dwh_04_rv`):
   - Contains Hubs, Links, and Satellites following Data Vault 2.0 methodology
   - Stores all historical data with load dates and source references

5. **Snapshot Layer** (`dwh_05_sn`):
   - Contains Point-in-Time (PIT) tables and Snapshot Views
   - Provides time-slice query capabilities for historical analysis

6. **Business Vault** (`dwh_06_bv`):
   - Contains business rules and transformations
   - Builds business-oriented structures based on Raw Vault data

7. **Information Marts** (`dwh_07_inmt`):
   - Dimensional models (facts and dimensions)
   - Provides business-friendly access for reporting and analytics

## Lineage Diagram

```mermaid
graph TD
    %% Source Systems
    WS[Webshop Source] --> |load_webshop_*| L[Loading Layer]
    RS[Roadshow Source] --> |load_roadshow_*| L
    MS[Misc Source] --> |load_misc_*| L
    
    %% Loading to Staging
    L --> |transform| S[Staging Layer]
    
    %% Staging to Raw Vault
    S --> |load| RV_H[Raw Vault - Hubs]
    S --> |load| RV_L[Raw Vault - Links]
    S --> |load| RV_S[Raw Vault - Satellites]
    S --> |load| RV_STS[Raw Vault - Status Tracking Satellites]
    
    %% Raw Vault to Snapshot Layer
    RV_H --> SN_PIT[Snapshot - PIT Tables]
    RV_L --> SN_PIT
    RV_S --> SN_PIT
    RV_STS --> SN_PIT
    
    SN_PIT --> SN_SNS[Snapshot - Snapshot Views]
    
    %% Snapshot to Business Vault
    SN_SNS --> BV_BS[Business Vault - Bridge Structures]
    SN_SNS --> BV_BB[Business Vault - Business Building Blocks]
    
    %% Business Vault to Information Marts
    BV_BS --> IM_D[Information Marts - Dimensions]
    BV_BB --> IM_F[Information Marts - Facts]
    
    %% Main entities
    subgraph "Main Business Entities"
        E_CUST[Customer]
        E_ORD[Order]
        E_PROD[Product]
        E_POS[Position]
        E_DEL[Delivery]
        E_ASSOC[Association Partner]
    end
```

## Key Business Entities and Their Flow

### Customer Entity Flow

```mermaid
graph TD
    %% Customer Entity Flow
    WS_KUNDE[webshop_kunde] --> |load_webshop_kunde| STG_KUNDE[stg_webshop_kunde]
    RS_BEST[roadshow_bestellung] --> |load_roadshow_bestellung| STG_RS_BEST[stg_roadshow_bestellung]
    
    STG_KUNDE --> |customer_bk, hash keys| CUST_H[customer_h]
    STG_RS_BEST --> |customer_bk, hash keys| CUST_H
    
    STG_KUNDE --> |descriptive attributes| CUST_WS_S[customer_ws_s]
    STG_KUNDE --> |status info| CUST_WS_STS[customer_ws_sts]
    
    CUST_H --> CUST_PIT[customer_snp]
    CUST_WS_S --> CUST_PIT
    CUST_WS_STS --> CUST_PIT
    
    CUST_PIT --> CUST_SNS[customer_sns]
    
    CUST_SNS --> CUST_BS[customer_bs]
    CUST_BS --> DIM_CUST[dim_customer]
```

### Sales/Order Flow

```mermaid
graph TD
    %% Order Entity Flow
    WS_BEST[webshop_bestellung] --> |load_webshop_bestellung| STG_WS_BEST[stg_webshop_bestellung]
    RS_BEST[roadshow_bestellung] --> |load_roadshow_bestellung| STG_RS_BEST[stg_roadshow_bestellung]
    
    STG_WS_BEST --> |order_bk, hash keys| ORDER_H[order_h]
    STG_RS_BEST --> |order_bk, hash keys| ORDER_H
    
    STG_WS_BEST --> |descriptive attributes| ORDER_WS_S[order_ws_s]
    
    %% Position Flow
    WS_POS[webshop_position] --> |load_webshop_position| STG_WS_POS[stg_webshop_position]
    RS_POS[roadshow positions] --> STG_RS_POS[stg positions from roadshow]
    
    STG_WS_POS --> |position_bk, hash keys| POS_H[position_h]
    STG_RS_POS --> |position_bk, hash keys| POS_H
    
    STG_WS_POS --> |descriptive attributes| POS_WS_S[position_ws_s]
    
    %% Links
    ORDER_H --> ORDER_POS_L[order_position_l]
    POS_H --> ORDER_POS_L
    
    POS_H --> POS_PROD_L[position_product_l]
    PROD_H[product_h] --> POS_PROD_L
    
    %% PITs and Snapshots
    ORDER_H --> ORDER_PIT[order_snp]
    ORDER_WS_S --> ORDER_PIT
    
    POS_H --> POS_PIT[position_snp]
    POS_WS_S --> POS_PIT
    
    ORDER_POS_L --> ORDER_POS_PIT[order_position_snp]
    
    ORDER_PIT --> ORDER_SNS[order_sns]
    POS_PIT --> POS_SNS[position_sns]
    ORDER_POS_PIT --> ORDER_POS_SNS[order_position_sns]
    
    %% Business Vault
    ORDER_SNS --> SALES_BB[sales_bb]
    POS_SNS --> SALES_BB
    ORDER_POS_SNS --> SALES_BB
    
    %% Information Mart
    SALES_BB --> FACT_SALES[fact_sales]
```

## Source-to-Target Details

### Key Data Sources

1. **Webshop Sources:**
   - kunde (customer)
   - bestellung (order)
   - position (line item)
   - produkt (product)
   - lieferung (delivery)
   - lieferadresse (delivery address)
   - lieferdienst (delivery service)
   - vereinspartner (association partner)
   - produktkategorie (product category)
   - wohnort (residence)

2. **Roadshow Sources:**
   - bestellung (order with customer data)

3. **Miscellaneous Sources:**
   - kategorie_termintreue (delivery adherence category)

### Information Mart (Dimensional Model)

The final dimensional model consists of:

**Facts:**
- fact_sales (sales transactions)
- fact_error (error records)

**Dimensions:**
- dim_customer (customer information)
- dim_product (product information)
- dim_productcategory (product category hierarchy)
- dim_associationpartner (association partner information)
- dim_category_deliveryadherence (delivery performance categories)
- dim_product_type (product type reference data)
- Time dimensions:
  - dim_sales_date (order date)
  - dim_delivery_date (delivery date)
  - dim_requested_date (requested delivery date)
  - dim_reporting_date (reporting context date)

## Data Vault Pattern Implementation

This project implements the full Data Vault 2.0 methodology, including:

1. **Hubs** - Store business keys with their hash keys
   - Example: `customer_h` stores the unique customer business keys

2. **Links** - Store relationships between business entities
   - Example: `order_position_l` links orders to their line items

3. **Satellites** - Store descriptive attributes for Hubs and Links
   - Example: `customer_ws_s` stores customer attributes from the webshop

4. **Status Tracking Satellites (STS)** - Track entity status changes
   - Example: `customer_ws_sts` tracks customer status changes

5. **Point-in-Time (PIT) Tables** - Store dates/times for historical queries
   - Example: `customer_snp` contains load date pointers for all customer satellites

6. **Snapshot Views** - Simplify point-in-time queries across satellites
   - Example: `customer_sns` pre-joins hub and satellites as of each snapshot date

The project uses a multi-source approach with source-specific satellites (e.g., `_ws_` for webshop, `_rs_` for roadshow).
