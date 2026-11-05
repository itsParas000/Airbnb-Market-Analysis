# Airbnb Market Intelligence & Analytics Pipeline (GCP, Python, BigQuery, Looker Studio)

An end-to-end cloud ELT data pipeline and interactive business intelligence dashboard analyzing 365-day forward-looking Airbnb booking dynamics, pricing elasticity, and host performance.

![Airbnb Market Intelligence Dashboard](/Screenshots/Dashboard.png)

---

## Executive Summary & Market Insights

Analyzed **248 verified listings** across **47,254 forward booked nights**, establishing a total estimated market volume of **$8.96M** with an **Average Daily Rate (ADR) of $190** and **30% average occupancy**.

* **Superhost Economic Moat:** Superhosts command an **18% pricing premium** ($203.22 vs. $172.61 ADR) while achieving higher occupancy (**33.17% vs. 25.43%**) and guest satisfaction (4.89 vs. 4.68 rating) compared to regular hosts.
* **Geographic Revenue Clustering:** Revenue is heavily concentrated in prime districts, led by **Sixth Ward (~$1.85M)** and **Second Ward (~$1.3M)**.
* **Supply Dominance:** The market is predominantly driven by **Entire home/apt accommodations (75.4%)**, with Private rooms holding 24.6% and Shared rooms remaining negligible (<1%).
* **Capacity Unit Economics:** Nightly pricing scales predictably from $80 (1 guest) to $360 (8 guests), with substantial pricing jumps ($550–$700+) for large-group inventory (10+ guests).

---

## 💡 Strategic Business Recommendations

Based on market analysis across 248 verified listings ($8.96M projected market revenue):

1. **Target Prime Geographic Locations:**
   - **Sixth Ward** and **Second Ward** capture the highest market demand, generating over $3.1M combined (~35% of total market revenue). New acquisitions should prioritize these districts.

2. **Asset Type & Unit Economics:**
   - **Entire home/apt** units dominate market demand (75.4% of supply) and command higher occupancy (~31% vs. ~26% for private rooms).
   - Target properties accommodating **6+ guests** to leverage steep pricing jumps ($300–$700/night) while maintaining steady advance booking pace.

3. **Operational Focus (Superhost Premium):**
   - Superhosts capture an **18% pricing premium** ($203.22 vs. $172.61 ADR) while maintaining an **8% higher occupancy rate** (33.17% vs. 25.43%) and superior guest ratings (4.89 vs. 4.68).
   - Fast-tracking Superhost qualifications (review velocity, zero cancellations, rapid response) directly drives bottom-line profitability.

---

## Technical Architecture & Pipeline

```text
[Raw Inside Airbnb Data] (Listings & 365-Day Calendar CSVs)
           │
           ▼
[Local / Cloud Python Preprocessing] (pandas, regex cleaning, encoding normalization)
           │
           ▼
[Google Cloud Storage (GCS)] (`gs://air-bnb/...`)
           │
           ▼
[Python Vertex AI Workbench] (Data profiling, duplicate audit, null audits)
           │
           ▼
[BigQuery ELT Modeling] (Standard SQL, window-function deduplication, grain aggregation)
           │
           ▼
[Looker Studio BI Layer] (Executive KPI scorecards, cohort benchmarking, distribution analytics)
