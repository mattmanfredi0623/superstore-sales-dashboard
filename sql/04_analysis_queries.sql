.bail on
.mode csv
.headers on

-- 1) Monthly performance
.once exports/monthly_performance.csv
SELECT
  substr(order_date, 1, 7) AS year_month,
  ROUND(SUM(sales), 2)     AS total_sales,
  ROUND(SUM(profit), 2)    AS total_profit,
  ROUND(SUM(shipping_cost),2) AS total_shipping_cost,
  COUNT(DISTINCT order_id) AS orders,
  SUM(quantity)            AS units,
  ROUND(AVG(discount), 4)  AS avg_discount
FROM superstore
GROUP BY year_month
ORDER BY year_month;

-- 2) Category / Sub-Category performance
.once exports/category_performance.csv
SELECT
  category,
  sub_category,
  ROUND(SUM(sales), 2)  AS sales,
  ROUND(SUM(profit), 2) AS profit,
  SUM(quantity)         AS units
FROM superstore
GROUP BY category, sub_category
ORDER BY category, sub_category;

-- 3) Region by month
.once exports/region_monthly.csv
SELECT
  substr(order_date, 1, 7) AS year_month,
  region,
  ROUND(SUM(sales), 2)  AS sales,
  ROUND(SUM(profit), 2) AS profit
FROM superstore
GROUP BY year_month, region
ORDER BY year_month, region;

-- 4) Market x Priority (extra, useful for Tableau filters)
.once exports/market_priority.csv
SELECT
  market,
  order_priority,
  ROUND(SUM(sales),2)  AS sales,
  ROUND(SUM(profit),2) AS profit,
  ROUND(SUM(shipping_cost),2) AS shipping_cost
FROM superstore
GROUP BY market, order_priority
ORDER BY market, order_priority;