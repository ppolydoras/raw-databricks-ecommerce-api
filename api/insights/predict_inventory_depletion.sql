-- @param product_id Filter by product ID.
-- @type product_id integer
-- @default product_id null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param sales_date_range_start Consider sales data from this date onwards (YYYY-MM-DD).
-- @type sales_date_range_start date
-- @default sales_date_range_start null

-- @param sales_date_range_end Consider sales data up to this date (YYYY-MM-DD).
-- @type sales_date_range_end date
-- @default sales_date_range_end null

-- @return Estimated days until inventory is depleted based on average daily sales.

WITH sales_data AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity) AS total_quantity_sold,
        COUNT(DISTINCT o.order_date) AS sales_days
    FROM databricks.order_items oi
    JOIN databricks.orders o ON oi.order_id = o.order_id
    WHERE (oi.product_id = :product_id OR :product_id IS NULL)
      AND (o.order_date >= :sales_date_range_start OR :sales_date_range_start IS NULL)
      AND (o.order_date <= :sales_date_range_end OR :sales_date_range_end IS NULL)
    GROUP BY oi.product_id
),
average_daily_sales AS (
    SELECT
        sd.product_id,
        sd.total_quantity_sold / NULLIF(sd.sales_days, 0) AS avg_daily_sales
    FROM databricks.sales_data sd
),
inventory_levels AS (
    SELECT
        i.product_id,
        i.quantity_in_stock,
        i.last_updated
    FROM databricks.inventory i
    WHERE (i.product_id = :product_id OR :product_id IS NULL)
),
depletion_estimation AS (
    SELECT
        al.product_id AS product_product_id,
        p.product_name AS product_product_name,
        il.quantity_in_stock AS inventory_quantity_in_stock,
        il.last_updated AS inventory_last_updated,
        al.avg_daily_sales AS sales_avg_daily_sales,
        CASE
            WHEN al.avg_daily_sales > 0 THEN il.quantity_in_stock / al.avg_daily_sales
            ELSE NULL
        END AS estimated_days_until_depletion
    FROM databricks.average_daily_sales al
    JOIN databricks.inventory_levels il ON al.product_id = il.product_id
    JOIN databricks.products p ON al.product_id = p.product_id
    WHERE (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
)
SELECT *
FROM databricks.depletion_estimation
ORDER BY estimated_days_until_depletion;
