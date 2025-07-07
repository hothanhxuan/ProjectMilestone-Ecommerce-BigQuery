SELECT 
      tb2.v2ProductName AS other_purchased_products
      ,SUM(tb2.productQuantity) AS quantity
FROM
(
SELECT 
      DISTINCT fullVisitorId 
      ,product.v2ProductName
      -- ,product.productRevenue
      -- ,product.productQuantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST(hits) AS hits,
UNNEST (hits.product) AS product
WHERE 1=1
      AND product.productRevenue is not null
      AND product.v2ProductName = "YouTube Men's Vintage Henley"
      AND totals.transactions >=1
) AS tb1
LEFT JOIN 
(
SELECT 
      fullVisitorId 
      ,product.v2ProductName 
      ,product.productQuantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST(hits) AS hits,
UNNEST (hits.product) AS product 
WHERE 1=1
      AND product.productRevenue is not null
      AND totals.transactions >=1
) AS tb2

USING (fullVisitorId)
WHERE tb2.v2ProductName <> "YouTube Men's Vintage Henley"
GROUP BY other_purchased_products
ORDER BY quantity DESC; 





-- Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017.
-- Output should show product name and the quantity was ordered.
-- "Hint1: We have to   , UNNEST(hits) AS hits
--   , UNNEST(hits.product) as product to get v2ProductName."
-- Hint2: Add condition "product.productRevenue is not null"," totals.transactions >=1" to calculate correctly
-- Hint3: Using productQuantity to calculate quantity.

-- OUTPUT 2 cột: other_purchased_products, quantity
