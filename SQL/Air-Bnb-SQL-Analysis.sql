-- cleaning & transformation

CREATE OR REPLACE TABLE `airbnb-analysis-513507.airbnb_data.master_analytics` AS
-- Step 1: Aggregate Calendar per Unique Listing ID
WITH calendar_agg AS(
  SELECT
    UPPER(TRIM(CAST(listing_id AS STRING))) AS listing_id,
    COUNT(1) AS total_calendar_days,
    COUNTIF(available = 'f') AS booked_days,
    ROUND(COUNTIF(available = 'f') / COUNT(1) * 100, 2) AS occupancy_rate,
  FROM `airbnb-analysis-513507.airbnb_data.calendar`
  GROUP BY 1
),

-- Step 2: Deduplicate Listings (keep strictly 1 unique row per ID)
listings_deduped AS(
  SELECT
    UPPER(TRIM(CAST(id AS STRING))) AS listing_id,
    name AS listing_name,
    neighbourhood_cleansed AS neighborhood,
    room_type,
    SAFE_CAST(accommodates AS INT64) AS accommodates,
    SAFE_CAST(bedrooms AS INT64) AS bedrooms,

    -- Impute beds: if null, default to accommodates or 1
    COALESCE(SAFE_CAST(beds AS INT64), SAFE_CAST(accommodates AS INT64), 1) AS beds,
    -- Clean price string to numeric float
    SAFE_CAST(REPLACE(REPLACE(CAST(price AS STRING), '$', ''), ',', '') AS FLOAT64) AS price,
    SAFE_CAST(review_scores_rating AS FLOAT64) AS rating,
    SAFE_CAST(number_of_reviews AS INT64) AS number_of_reviews,
    CASE WHEN host_is_superhost = TRUE THEN 'Superhost' ELSE 'Regular Host' END AS host_status
  FROM `airbnb-analysis-513507.airbnb_data.listings`
  QUALIFY ROW_NUMBER() OVER(
    PARTITION BY UPPER(TRIM(CAST(id AS STRING))) 
    ORDER BY SAFE_CAST(number_of_reviews AS INT64) DESC, price DESC
  ) = 1
)

-- Step 3: Join Deduplicated Listings with Calendar Aggregations
SELECT 
  l.listing_id,
  l.listing_name,
  l.neighborhood,
  l.room_type,
  l.accommodates,
  l.bedrooms,
  l.beds,
  l.price,
  l.rating,
  l.number_of_reviews,
  l.host_status,
  COALESCE(c.occupancy_rate, 0.0) AS occupancy_rate,
  COALESCE(c.booked_days, 0) AS booked_days,
  ROUND(COALESCE(c.booked_days, 0) * l.price, 2) AS estimated_annual_revenue
FROM listings_deduped l
LEFT JOIN calendar_agg c
  ON l.listing_id = c.listing_id
WHERE l.price IS NOT NULL 
  AND l.price > 0 
  AND l.price < 10000;



-- Verify the summary
SELECT 
  COUNT(*) AS total_clean_listings,
  COUNT(DISTINCT listing_id) AS unique_listings,
  SUM(booked_days) AS total_market_booked_nights,
  ROUND(SUM(estimated_annual_revenue), 2) AS total_market_revenue,
  ROUND(AVG(price), 2) AS avg_daily_rate,
  ROUND(AVG(occupancy_rate), 2) AS avg_market_occupancy
FROM `airbnb-analysis-513507.airbnb_data.master_analytics`;

