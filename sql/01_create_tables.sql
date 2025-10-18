.bail on

DROP TABLE IF EXISTS superstore_raw;
CREATE TABLE superstore_raw (
  order_id      TEXT,
  order_date    TEXT,
  ship_date     TEXT,
  ship_mode     TEXT,
  customer_name TEXT,
  segment       TEXT,
  state         TEXT,
  country       TEXT,
  market        TEXT,
  region        TEXT,
  product_id    TEXT,
  category      TEXT,
  sub_category  TEXT,
  product_name  TEXT,
  sales         TEXT,
  quantity      TEXT,
  discount      TEXT,
  profit        TEXT,
  shipping_cost TEXT,
  order_priority TEXT,
  year          TEXT
);

DROP TABLE IF EXISTS superstore;
CREATE TABLE superstore (
  order_id       TEXT,
  order_date     TEXT,  -- ISO YYYY-MM-DD
  ship_date      TEXT,
  ship_mode      TEXT,
  customer_name  TEXT,
  segment        TEXT,
  state          TEXT,
  country        TEXT,
  market         TEXT,
  region         TEXT,
  product_id     TEXT,
  category       TEXT,
  sub_category   TEXT,
  product_name   TEXT,
  sales          REAL,
  quantity       INTEGER,
  discount       REAL,
  profit         REAL,
  shipping_cost  REAL,
  order_priority TEXT,
  year           INTEGER
);