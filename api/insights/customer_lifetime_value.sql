-- @param customer_id Filter by customer ID.
-- @type customer_id integer
-- @default customer_id null

-- @param customer_first_name Filter by customer's first name (partial match).
-- @type customer_first_name varchar
-- @default customer_first_name null

-- @param customer_last_name Filter by customer's last name (partial match).
-- @type customer_last_name varchar
-- @default customer_last_name null

-- @param order_date_range_start Consider orders from this date onwards (YYYY-MM-DD).
-- @type order_date_range_start date
-- @default order_date_range_start null

-- @param order_date_range_end Consider orders up to this date (YYYY-MM-DD).
-- @type order_date_range_end date
-- @default order_date_range_end null

-- @return Estimated Customer Lifetime Value (CLV) for customers.

WITH customer_orders AS (
    SELECT
        c.customer_id AS customer_customer_id,
        c.first_name AS customer_first_name,
        c.last_name AS customer_last_name,
        o.order_date AS order_order_date,
        o.total_amount AS order_total_amount
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE (c.customer_id = :customer_id OR :customer_id IS NULL)
      AND (c.first_name ILIKE CONCAT('%', :customer_first_name, '%') OR :customer_first_name IS NULL)
      AND (c.last_name ILIKE CONCAT('%', :customer_last_name, '%') OR :customer_last_name IS NULL)
      AND (o.order_date >= :order_date_range_start OR :order_date_range_start IS NULL)
      AND (o.order_date <= :order_date_range_end OR :order_date_range_end IS NULL)
),
customer_clv AS (
    SELECT
        co.customer_customer_id,
        co.customer_first_name,
        co.customer_last_name,
        AVG(co.order_total_amount) AS average_order_value,
        COUNT(DISTINCT co.order_order_date) / NULLIF(DATE_PART('year', MAX(co.order_order_date) - MIN(co.order_order_date)) + 1, 0) AS purchase_frequency_per_year,
        (AVG(co.order_total_amount) * (COUNT(co.order_order_date) / NULLIF(DATE_PART('year', MAX(co.order_order_date) - MIN(co.order_order_date)) + 1, 0))) AS customer_lifetime_value
    FROM customer_orders co
    GROUP BY co.customer_customer_id, co.customer_first_name, co.customer_last_name
)
SELECT
    customer_customer_id,
    customer_first_name,
    customer_last_name,
    average_order_value,
    purchase_frequency_per_year,
    customer_lifetime_value
FROM customer_clv
ORDER BY customer_lifetime_value DESC;
