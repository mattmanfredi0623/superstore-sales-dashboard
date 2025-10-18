.bail on
.mode csv
.headers off

DELETE FROM superstore_raw;

.import --skip 1 data/SuperStoreOrders_clean.csv superstore_raw

-- sanity check
SELECT COUNT(*) AS raw_rows FROM superstore_raw;