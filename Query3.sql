WITH raw_data AS
(
SELECT
      trafficSource.source AS source
      ,PARSE_DATE('%Y%m%d', date) AS parsed_date
      ,product.productRevenue / 1000000 AS revenue_million
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
UNNEST(hits) AS hits,
UNNEST(hits.product) AS product
WHERE product.productRevenue IS NOT NULL
ORDER BY revenue_million DESC 
)

SELECT
      'Week' AS type_time
      ,FORMAT_DATE('%Y%V', parsed_date) AS time
      ,source
      ,ROUND(SUM(revenue_million), 4) AS revenue
FROM raw_data
GROUP BY source, type_time, time

UNION ALL 

SELECT
      'Month' AS type_time
      ,FORMAT_DATE('%Y%m', parsed_date) AS time
      ,source
      ,ROUND(SUM(revenue_million), 4) AS revenue
FROM raw_data
GROUP BY source, type_time, time

ORDER BY revenue DESC;


-- Revenue by traffic source by week, by month in June 2017
-- Hint 1: separate month and week data then union all.
-- Hint 2: at time_type, you can [SELECT 'Month' as time_type] to print time_type column
-- Hint 3: use "productRevenue" to calculate revenue. You need to unnest hits and product to access productRevenue field (example at the end of page).
-- Hint 4: To shorten the result, productRevenue should be divided by 1000000
-- Hint 5: Add condition "product.productRevenue is not null" to calculate correctly

-- OUTPUT 4 cột: time_type, time, source, revenue 
