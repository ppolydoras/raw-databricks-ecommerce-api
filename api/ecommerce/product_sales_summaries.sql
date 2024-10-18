-- @param product_id Filter by product ID.
-- @type product_id integer
-- @default product_id null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param category_name Filter by category name (partial match).
-- @type category_name varchar
-- @default category_name null

-- @param sales_date_range_start Filter sales on or after this date (YYYY-MM-DD).
-- @type sales_date_range_start date
-- @default sales_date_range_start null

-- @param sales_date_range_end Filter sales on or before this date (YYYY-MM-DD).
-- @type sales_date_range_end date
-- @default sales_date_range_end null

-- @return A summary of sales per product, including total quantity sold and total sales amount.

WITH product_sales_summaries AS (
    SELECT
        p.product_id AS product_product_id,
        p.product_name AS product_product_name,
        c.category_name AS category_category_name,
        SUM(oi.quantity) AS product_total_quantity_sold,
        SUM(oi.quantity * oi.unit_price) AS product_total_sales_amount
    FROM databricks.products p
    JOIN databricks.order_items oi ON p.product_id = oi.product_id
    JOIN databricks.orders o ON oi.order_id = o.order_id
    JOIN databricks.categories c ON p.category_id = c.category_id
    WHERE (p.product_id = :product_id OR :product_id IS NULL)
      AND (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
      AND (c.category_name ILIKE CONCAT('%', :category_name, '%') OR :category_name IS NULL)
      AND (o.order_date >= :sales_date_range_start OR :sales_date_range_start IS NULL)
      AND (o.order_date <= :sales_date_range_end OR :sales_date_range_end IS NULL)
    GROUP BY p.product_id, p.product_name, c.category_name
)
SELECT *
FROM product_sales_summaries
ORDER BY product_total_sales_amount DESC;
