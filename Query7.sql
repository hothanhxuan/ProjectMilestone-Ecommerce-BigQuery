with buyer_list as(
    SELECT
        distinct fullVisitorId  
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    , UNNEST(hits) AS hits
    , UNNEST(hits.product) as product
    WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
    AND totals.transactions>=1
    AND product.productRevenue is not null
)

SELECT
  product.v2ProductName AS other_purchased_products,
  SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
JOIN buyer_list using(fullVisitorId)
WHERE product.v2ProductName != "YouTube Men's Vintage Henley"
 and product.productRevenue is not null
 AND totals.transactions>=1
GROUP BY other_purchased_products
ORDER BY quantity DESC;





-- Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017.
-- Output should show product name and the quantity was ordered.
-- "Hint1: We have to   , UNNEST(hits) AS hits
--   , UNNEST(hits.product) as product to get v2ProductName."
-- Hint2: Add condition "product.productRevenue is not null"," totals.transactions >=1" to calculate correctly
-- Hint3: Using productQuantity to calculate quantity.

-- OUTPUT 2 cột: other_purchased_products, quantity
