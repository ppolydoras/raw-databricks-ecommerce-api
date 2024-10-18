-- @param customer_id Filter by customer ID.
-- @type customer_id integer
-- @default customer_id null

-- @param customer_first_name Filter by customer's first name (partial match).
-- @type customer_first_name varchar
-- @default customer_first_name null

-- @param customer_last_name Filter by customer's last name (partial match).
-- @type customer_last_name varchar
-- @default customer_last_name null

-- @param order_date_range_start Filter orders placed on or after this date (YYYY-MM-DD).
-- @type order_date_range_start date
-- @default order_date_range_start null

-- @param order_date_range_end Filter orders placed on or before this date (YYYY-MM-DD).
-- @type order_date_range_end date
-- @default order_date_range_end null

-- @return A summary of orders per customer, including total orders and total amount spent.

WITH customer_order_summaries AS (
    SELECT
        c.customer_id AS customer_customer_id,
        c.first_name AS customer_first_name,
        c.last_name AS customer_last_name,
        COUNT(o.order_id) AS customer_total_orders,
        SUM(o.total_amount) AS customer_total_spent
    FROM databricks.customers c
    LEFT JOIN databricks.orders o ON c.customer_id = o.customer_id
        AND (o.order_date >= :order_date_range_start OR :order_date_range_start IS NULL)
        AND (o.order_date <= :order_date_range_end OR :order_date_range_end IS NULL)
    WHERE (c.customer_id = :customer_id OR :customer_id IS NULL)
      AND (c.first_name ILIKE CONCAT('%', :customer_first_name, '%') OR :customer_first_name IS NULL)
      AND (c.last_name ILIKE CONCAT('%', :customer_last_name, '%') OR :customer_last_name IS NULL)
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *
FROM customer_order_summaries
ORDER BY customer_total_spent DESC;
