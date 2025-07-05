SELECT    
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month 
      ,SUM(totals.visits) AS visits 
      ,SUM(totals.pageviews) AS pageviews 
      ,SUM(totals.transactions) AS transactions 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
GROUP BY month
ORDER BY month

-- calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
--output 4 cột: months, visits, pageviews, transactions 
