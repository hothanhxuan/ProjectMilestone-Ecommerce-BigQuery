-- Code 1
SELECT
      pur.month
      ,pur.avg_pageviews_purchase
      ,non.avg_pageviews_non_purchase
FROM
(SELECT  
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month 
      ,SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) AS hits,
UNNEST (hits.product) AS product
WHERE product.productRevenue IS NOT NULL 
  AND totals.transactions >=1 
  AND PARSE_DATE('%Y%m%d', date) BETWEEN '2017-06-01' AND '2017-07-31'
GROUP BY month) AS pur

LEFT JOIN 

(SELECT  
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
      ,SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS  avg_pageviews_non_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) AS hits,
UNNEST (hits.product) AS product
WHERE product.productRevenue IS NULL 
  AND totals.transactions IS NULL
  AND PARSE_DATE('%Y%m%d', date) BETWEEN '2017-06-01' AND '2017-07-31'
GROUP BY month) AS non 

ON pur.month = non.month; 

-- Code 2
with 
purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions>=1
  and product.productRevenue is not null
  group by month
),

non_purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions is null
  and product.productRevenue is null
  group by month
)

select
    pd.*,
    avg_pageviews_non_purchase
from purchaser_data pd
full join non_purchaser_data using(month)
order by pd.month;

-- Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
-- Note: fullVisitorId field is user id.

-- Hint 1: purchaser: totals.transactions >=1; productRevenue is not null. 
-- Hint 2: non-purchaser: totals.transactions IS NULL;  product.productRevenue is null 
-- Hint 3: Avg pageview = total pageview / number unique user ,  totals.pageviews
-- OUTPUT 3 cột: month, avg_pageviews_purchase, avg_pageviews_non_purchase

