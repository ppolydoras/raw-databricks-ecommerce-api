-- @param segment_type Type of segmentation ('high_value', 'medium_value', 'low_value').
-- @type segment_type varchar
-- @default segment_type null

-- @param order_date_range_start Consider orders from this date onwards (YYYY-MM-DD).
-- @type order_date_range_start date
-- @default order_date_range_start null

-- @param order_date_range_end Consider orders up to this date (YYYY-MM-DD).
-- @type order_date_range_end date
-- @default order_date_range_end null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return Customers segmented based on their total spend.

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE (o.order_date >= :order_date_range_start OR :order_date_range_start IS NULL)
      AND (o.order_date <= :order_date_range_end OR :order_date_range_end IS NULL)
    GROUP BY c.customer_id, c.first_name, c.last_name
),
spending_stats AS (
    SELECT
        AVG(total_spent) AS avg_spent,
        STDDEV(total_spent) AS stddev_spent
    FROM customer_totals
),
segmented_customers AS (
    SELECT
        ct.customer_id AS customer_customer_id,
        ct.first_name AS customer_first_name,
        ct.last_name AS customer_last_name,
        ct.total_spent AS customer_total_spent,
        CASE
            WHEN ct.total_spent >= (ss.avg_spent + ss.stddev_spent) THEN 'high_value'
            WHEN ct.total_spent BETWEEN (ss.avg_spent - ss.stddev_spent) AND (ss.avg_spent + ss.stddev_spent) THEN 'medium_value'
            ELSE 'low_value'
        END AS customer_segment
    FROM customer_totals ct
    CROSS JOIN spending_stats ss
)
SELECT *
FROM segmented_customers
WHERE (customer_segment = :segment_type OR :segment_type IS NULL)
ORDER BY customer_total_spent DESC
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
