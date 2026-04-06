# Project 1: Understanding E-commerce User Behavior Using Google Analytics Data in BigQuery

## 💡 Overview

**ProjectMilestone-Ecommerce-BigQuery** is a data analytics project focused on understanding and analyzing user behavior for an E-commerce company. This project uses a publicly available Google Analytics dataset hosted on BigQuery to explore website traffic, conversion funnels, and marketing performance.

---

## 📊 Dataset

- **Source:** [bigquery-public-data](https://console.cloud.google.com/marketplace/details/google/ga360-sample)
- **Dataset:** `ga_sessions_*`
- **Folder:** `ga_sessions`
- **Description:**  
  This dataset contains sample Google Analytics data collected from an actual E-commerce website. It includes user sessions, transactions, traffic sources, device details, geographic data, and more, providing a comprehensive view of user interactions.

---

## 🚀 Objectives

- Analyze overall website traffic trends
- Identify the most valuable traffic sources
- Examine conversion rates and purchase funnels
- Analyze product performance and top-selling items
- Provide actionable insights for marketing and business strategy

---

## ⚙️ Main Process - 8 main questions to write queries

### 1️⃣ Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)

#### 🧩 Queries ####
```sql
SELECT    
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month 
      ,SUM(totals.visits) AS visits 
      ,SUM(totals.pageviews) AS pageviews 
      ,SUM(totals.transactions) AS transactions 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
GROUP BY month
ORDER BY month;
```
#### 💎 Queries result ####


### 2️⃣ Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC) ### 

#### 🧩 Queries ####
```sql
SELECT  
      trafficSource.source
      ,SUM(totals.visits) AS total_visits
      ,SUM(totals.bounces) AS total_no_of_bounces
      ,ROUND((SUM(totals.bounces)/SUM(totals.visits))*100.0, 3) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY trafficSource.source 
ORDER BY total_visits DESC;
```
#### 💎 Queries result ####

### 3️⃣ Revenue by traffic source by week, by month in June 2017 ###

#### 🧩 Queries ####
```sql
with 
month_data as(
  SELECT
    "Month" as time_type,
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    trafficSource.source AS source,
    SUM(p.productRevenue)/1000000 AS revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  WHERE p.productRevenue is not null
  GROUP BY 1,2,3
  order by revenue DESC
),

week_data as(
  SELECT
    "Week" as time_type,
    format_date("%Y%W", parse_date("%Y%m%d", date)) as week,
    trafficSource.source AS source,
    SUM(p.productRevenue)/1000000 AS revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  WHERE p.productRevenue is not null
  GROUP BY 1,2,3
  order by revenue DESC
)

select * from month_data
union all
select * from week_data
order by time_type;
```
#### 💎 Queries result ####

### 4️⃣ Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017. ### 

#### 🧩 Queries ####
```sql
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
```
#### 💎 Queries result ####


### 5️⃣ Average number of transactions per user that made a purchase in July 2017 ### 

#### 🧩 Queries ####
```sql
SELECT  
      FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d', date)) AS Month 
      ,SUM(totals.transactions) / COUNT(DISTINCT fullVisitorId) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST (hits) AS hits,
UNNEST (hits.product) AS product 
WHERE product.productRevenue IS NOT NULL 
  AND totals.transactions >=1 
GROUP BY Month;
```
#### 💎 Queries result ####

### 6️⃣ Average amount of money spent per session. Only include purchaser data in July 2017 ### 

#### 🧩 Queries ####
```sql
SELECT  
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS Month 
      ,ROUND(SUM(product.productRevenue / 1000000 ) / SUM(totals.visits),2) AS avg_revenue_by_user_per_visit 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST (hits) AS hits,
UNNEST (hits.product) AS product 
WHERE totals.transactions IS NOT NULL 
  AND product.productRevenue IS NOT NULL 
GROUP BY Month;
```
#### 💎 Queries result ####


### 7️⃣ Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered. ### 

#### 🧩 Queries ####
```sql
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
```
#### 💎 Queries result ####


### 8️⃣ Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.
Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level. ### 

#### 🧩 Queries ####
```sql
-- Code 1:using CTE  
with
product_view as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_product_view
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '2'
  GROUP BY 1
),

add_to_cart as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_addtocart
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '3'
  GROUP BY 1
),

purchase as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '6'
  and product.productRevenue is not null   
  group by 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month;


-- Code 2: using count(case when) or sum(case when)

with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CASE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,UNNEST(hits) as hits
,UNNEST (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select
    *,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data;
```
#### 💎 Queries result ####


---

## 🔎 Final Conclusion & Recommendations 


