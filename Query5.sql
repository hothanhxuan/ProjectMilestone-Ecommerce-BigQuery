SELECT  
      FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d', date)) AS Month 
      ,SUM(totals.transactions) / COUNT(DISTINCT fullVisitorId) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST (hits) AS hits,
UNNEST (hits.product) AS product 
WHERE product.productRevenue IS NOT NULL 
  AND totals.transactions >=1 
GROUP BY Month; 

-- Average number of transactions per user that made a purchase in July 2017
-- Hint 1: purchaser: totals.transactions >=1; productRevenue is not null. fullVisitorId field is user id.
-- Hint 2: Add condition "product.productRevenue is not null" to calculate correctly
-- OUTPUT 2 cột: Month, Avg_total_transactions_per_user
