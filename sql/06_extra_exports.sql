.bail on
.mode csv
.headers on


.once exports/customer_leaderboard.csv
WITH agg AS (
  SELECT
    customer_name,
    ROUND(SUM(sales),2)  AS sales,
    ROUND(SUM(profit),2) AS profit,
    SUM(quantity)        AS units,
    COUNT(DISTINCT order_id) AS orders
  FROM superstore
  GROUP BY customer_name
),
r AS (
  SELECT *, RANK() OVER (ORDER BY sales DESC) AS sales_rank
  FROM agg
)
SELECT * FROM r WHERE sales_rank <= 100 ORDER BY sales_rank;

.once exports/top_products.csv
WITH agg AS (
  SELECT
    product_id, product_name, category, sub_category,
    ROUND(SUM(sales),2)  AS sales,
    ROUND(SUM(profit),2) AS profit,
    SUM(quantity)        AS units
  FROM superstore
  GROUP BY product_id, product_name, category, sub_category
),
r AS (
  SELECT *, RANK() OVER (ORDER BY sales DESC) AS sales_rank
  FROM agg
)
SELECT * FROM r WHERE sales_rank <= 100 ORDER BY sales_rank;

.once exports/state_performance.csv
SELECT
  country,
  state,
  ROUND(SUM(sales),2)  AS sales,
  ROUND(SUM(profit),2) AS profit,
  SUM(quantity)        AS units
FROM superstore
GROUP BY country, state
ORDER BY country, state;

.once exports/monthly_spine_zero_filled.csv
WITH bounds AS (
  SELECT DATE(MIN(order_date)) AS min_d, DATE(MAX(order_date)) AS max_d FROM superstore
),
months(m) AS (
  SELECT DATE(strftime('%Y-%m-01', min_d)) FROM bounds
  UNION ALL
  SELECT DATE(strftime('%Y-%m-01', DATE(m, '+1 month'))) FROM months, bounds
  WHERE DATE(m, '+1 month') <= (SELECT max_d FROM bounds)
),
agg AS (
  SELECT substr(order_date,1,7) AS ym,
         ROUND(SUM(sales),2)  AS total_sales,
         ROUND(SUM(profit),2) AS total_profit,
         SUM(quantity)        AS units
  FROM superstore
  GROUP BY ym
)
SELECT
  strftime('%Y-%m', m) AS year_month,
  COALESCE(agg.total_sales, 0)  AS total_sales,
  COALESCE(agg.total_profit, 0) AS total_profit,
  COALESCE(agg.units, 0)        AS units
FROM months
LEFT JOIN agg ON agg.ym = strftime('%Y-%m', m)
ORDER BY year_month;

.once exports/state_monthly.csv
SELECT
  substr(order_date,1,7) AS year_month,
  country,
  state,
  ROUND(SUM(sales),2)  AS sales,
  ROUND(SUM(profit),2) AS profit
FROM superstore
GROUP BY year_month, country, state
ORDER BY year_month, country, state;