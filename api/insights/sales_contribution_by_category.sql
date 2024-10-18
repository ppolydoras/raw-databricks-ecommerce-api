-- @param category_name Filter by category name (partial match).
-- @type category_name varchar
-- @default category_name null

-- @return Sales totals and percentage contribution for each category.

WITH category_sales AS (
    SELECT
        c.category_id AS category_category_id,
        c.category_name AS category_category_name,
        SUM(oi.quantity * oi.unit_price) AS category_total_sales
    FROM databricks.categories c
    JOIN databricks.products p ON c.category_id = p.category_id
    JOIN databricks.order_items oi ON p.product_id = oi.product_id
    WHERE (c.category_name ILIKE CONCAT('%', :category_name, '%') OR :category_name IS NULL)
    GROUP BY c.category_id, c.category_name
),
total_sales AS (
    SELECT
        SUM(category_total_sales) AS total_sales_amount
    FROM databricks.category_sales
)
SELECT
    cs.category_category_id,
    cs.category_category_name,
    cs.category_total_sales,
    (cs.category_total_sales / ts.total_sales_amount) * 100 AS category_sales_percentage
FROM category_sales cs
CROSS JOIN total_sales ts
ORDER BY cs.category_total_sales DESC;
