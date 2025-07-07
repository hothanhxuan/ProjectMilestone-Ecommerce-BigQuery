SELECT  
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS Month 
      ,ROUND(SUM(product.productRevenue / 1000000 ) / SUM(totals.visits),2) AS avg_revenue_by_user_per_visit 
      -- ,product.productRevenue / 1000000 AS revenue_million
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST (hits) AS hits,
UNNEST (hits.product) AS product 
WHERE totals.transactions IS NOT NULL 
  AND product.productRevenue IS NOT NULL 
GROUP BY Month; 




-- Average amount of money spent per session. Only include purchaser data in July 2017
-- Hint 1: Where clause must be include "totals.transactions IS NOT NULL" and "product.productRevenue is not null"
-- Hint 2: avg_spend_per_session = total revenue/ total visit
-- Hint 3: To shorten the result, productRevenue should be divided by 1000000
-- ***Notice: per visit is different to per visitor

-- OUTPUT 2 cột: Month, avg_revenue_by_user_per_visit 
