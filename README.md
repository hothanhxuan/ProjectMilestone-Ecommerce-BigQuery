# ProjectMilestone-Ecommerce-BigQuery

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

## ⚙️ How to use

### 1️⃣ Prerequisites

- Google Cloud account with BigQuery access
- Python 3.x environment (or Google Colab)
- Python libraries: `pandas`, `google-cloud-bigquery`, `matplotlib`, `seaborn` (for visualization)

### 2️⃣ Example BigQuery SQL query

```sql
SELECT
  date,
  fullVisitorId,
  visitId,
  channelGrouping,
  device.category AS device_category,
  geoNetwork.country,
  totals.pageviews,
  totals.transactionRevenue / 1e6 AS revenue
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND totals.transactions IS NOT NULL

---

## ❔ 8 main questions to write queries

1. Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
2. Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
3. Revenue by traffic source by week, by month in June 2017
4. Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
5. Average number of transactions per user that made a purchase in July 2017
6. Average amount of money spent per session. Only include purchaser data in July 2017
7. Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
8. Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.
Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level.

