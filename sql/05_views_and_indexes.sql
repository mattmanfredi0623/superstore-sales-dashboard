.bail on

-- Derived metrics you’ll reuse in Tableau
DROP VIEW IF EXISTS v_superstore_enriched;
CREATE VIEW v_superstore_enriched AS
SELECT
  order_id,
  order_date,
  ship_date,
  ship_mode,
  customer_name,
  segment,
  state,
  country,
  market,
  region,
  product_id,
  category,
  sub_category,
  product_name,
  sales,
  quantity,
  discount,
  profit,
  shipping_cost,
  (profit - shipping_cost) AS net_profit,
  CASE WHEN sales <> 0 THEN profit / sales END       AS margin_pct,
  CASE WHEN sales <> 0 THEN shipping_cost / sales END AS ship_pct
FROM superstore;

-- Helpful indexes for faster exports/iterative queries
DROP INDEX IF EXISTS idx_superstore_order_date;
CREATE INDEX idx_superstore_order_date ON superstore(order_date);

DROP INDEX IF EXISTS idx_superstore_region_month;
CREATE INDEX idx_superstore_region_month ON superstore(region, order_date);

DROP INDEX IF EXISTS idx_superstore_cat_subcat;
CREATE INDEX idx_superstore_cat_subcat ON superstore(category, sub_category);