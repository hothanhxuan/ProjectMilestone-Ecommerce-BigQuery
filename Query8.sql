SELECT 
      month
      ,num_product_view
      ,num_addtocart
      ,num_purchase
      ,ROUND((num_addtocart / num_product_view) * 100.0, 2) AS add_to_cart_rate
      ,ROUND((num_purchase / num_product_view) * 100.0, 2) AS purchase_rate
FROM
(
SELECT  
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
      ,COUNT(eCommerceAction.action_type) AS num_product_view
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product 
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
  AND  eCommerceAction.action_type = '2'
GROUP BY month
ORDER BY month
) 
LEFT JOIN 
(
SELECT  
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
      ,COUNT(eCommerceAction.action_type) AS num_addtocart
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product 
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
  AND  eCommerceAction.action_type = '3'
GROUP BY month
ORDER BY month
)
USING (month)
LEFT JOIN 
(
SELECT  
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
      ,COUNT(eCommerceAction.action_type) AS num_purchase 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product 
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
  AND eCommerceAction.action_type = '6'
  AND product.productRevenue IS NOT NULL 
GROUP BY month
ORDER BY month
)
USING(month)

ORDER BY month; 

-- Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. 
-- For example, 100% product view then 40% add_to_cart and 10% purchase.
-- Add_to_cart_rate = number product  add to cart/number product view. 
-- Purchase_rate = number product purchase/number product view. 
-- The output should be calculated in product level.

-- Hint 1: hits.eCommerceAction.action_type = '2' is view product page; 
-- hits.eCommerceAction.action_type = '3' is add to cart; hits.eCommerceAction.action_type = '6' is purchase
-- Hint 2: Add condition "product.productRevenue is not null"  for purchase to calculate correctly
-- Hint 3: To access action_type, you only need unnest hits

-- OUTPUT 6 cột: month, num_product_view, num_addtocart, num_purchase, add_to_cart_rate, purchase_rate
