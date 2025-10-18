.bail on
BEGIN;

DELETE FROM superstore;

INSERT INTO superstore (
  order_id, order_date, ship_date, ship_mode, customer_name, segment,
  state, country, market, region, product_id, category, sub_category,
  product_name, sales, quantity, discount, profit, shipping_cost,
  order_priority, year
)
SELECT
  NULLIF(order_id,''),
  NULLIF(order_date,''),
  NULLIF(ship_date,''),
  NULLIF(ship_mode,''),
  NULLIF(customer_name,''),
  NULLIF(segment,''),
  NULLIF(state,''),
  NULLIF(country,''),
  NULLIF(market,''),
  NULLIF(region,''),
  NULLIF(product_id,''),
  NULLIF(category,''),
  NULLIF(sub_category,''),
  NULLIF(product_name,''),
  CAST(NULLIF(REPLACE(REPLACE(sales, ',', ''), '$',''),'') AS REAL),
  CAST(NULLIF(REPLACE(quantity, ',', ''),'') AS INTEGER),
  CAST(NULLIF(REPLACE(discount, ',', ''),'') AS REAL),
  CAST(NULLIF(REPLACE(REPLACE(profit, ',', ''), '$',''),'') AS REAL),
  CAST(NULLIF(REPLACE(REPLACE(shipping_cost, ',', ''), '$',''),'') AS REAL),
  NULLIF(order_priority,''),
  CAST(NULLIF(year,'') AS INTEGER)
FROM superstore_raw;

COMMIT;

-- QC
SELECT
  COUNT(*) AS clean_rows,
  SUM(CASE WHEN order_date IS NULL OR order_date='' THEN 1 END) AS blank_order_dates
FROM superstore;