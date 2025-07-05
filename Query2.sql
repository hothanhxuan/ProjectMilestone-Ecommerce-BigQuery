SELECT  
      trafficSource.source
      ,SUM(totals.visits) AS total_visits
      ,SUM(totals.bounces) AS total_no_of_bounces
      ,ROUND((SUM(totals.bounces)/SUM(totals.visits))*100.0, 3) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY trafficSource.source 
ORDER BY total_visits DESC

-- Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
-- Hint: Bounce session is the session that user does not raise any click after landing on the website
-- OUTPUT 4 cột: source, total_visits, total_no_of_bounces, bounce_rate 
