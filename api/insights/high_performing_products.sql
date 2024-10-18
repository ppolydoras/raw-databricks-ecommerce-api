-- @param min_average_rating Minimum average rating (1-5).
-- @type min_average_rating decimal
-- @default min_average_rating null

-- @param min_total_sales Minimum total sales amount.
-- @type min_total_sales decimal
-- @default min_total_sales null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @return Products with average ratings and total sales above specified thresholds.

WITH product_ratings AS (
    SELECT
        r.product_id,
        AVG(r.rating) AS average_rating
    FROM databricks.reviews r
    GROUP BY r.product_id
),
product_sales AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM databricks.order_items oi
    GROUP BY oi.product_id
),
average_values AS (
    SELECT
        AVG(pr.average_rating) AS avg_rating,
        AVG(ps.total_sales) AS avg_sales
    FROM databricks.product_ratings pr
    JOIN databricks.product_sales ps ON pr.product_id = ps.product_id
),
high_performing_products AS (
    SELECT
        p.product_id AS product_product_id,
        p.product_name AS product_product_name,
        pr.average_rating AS product_average_rating,
        ps.total_sales AS product_total_sales
    FROM databricks.products p
    JOIN product_ratings pr ON p.product_id = pr.product_id
    JOIN product_sales ps ON p.product_id = ps.product_id
    WHERE pr.average_rating >= COALESCE(:min_average_rating, (SELECT avg_rating FROM databricks.average_values))
      AND ps.total_sales >= COALESCE(:min_total_sales, (SELECT avg_sales FROM databricks.average_values))
      AND (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
)
SELECT *
FROM high_performing_products
ORDER BY product_total_sales DESC;
