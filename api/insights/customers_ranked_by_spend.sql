-- @param customer_first_name Filter by customer's first name (partial match).
-- @type customer_first_name varchar
-- @default customer_first_name null

-- @param customer_last_name Filter by customer's last name (partial match).
-- @type customer_last_name varchar
-- @default customer_last_name null

-- @param order_date_range_start Include orders placed on or after this date (YYYY-MM-DD).
-- @type order_date_range_start date
-- @default order_date_range_start null

-- @param order_date_range_end Include orders placed on or before this date (YYYY-MM-DD).
-- @type order_date_range_end date
-- @default order_date_range_end null

-- @param min_total_spent Minimum total amount spent by the customer.
-- @type min_total_spent decimal
-- @default min_total_spent null

-- @param max_total_spent Maximum total amount spent by the customer.
-- @type max_total_spent decimal
-- @default max_total_spent null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A ranking of customers based on total spend within the specified date range, including filters and pagination.

WITH customer_totals AS (
    SELECT
        c.customer_id AS customer_customer_id,
        c.first_name AS customer_first_name,
        c.last_name AS customer_last_name,
        c.email AS customer_email,
        SUM(o.total_amount) AS customer_total_spent
    FROM databricks.customers c
    JOIN databricks.orders o ON c.customer_id = o.customer_id
    WHERE (c.first_name ILIKE CONCAT('%', :customer_first_name, '%') OR :customer_first_name IS NULL)
      AND (c.last_name ILIKE CONCAT('%', :customer_last_name, '%') OR :customer_last_name IS NULL)
      AND (o.order_date >= :order_date_range_start OR :order_date_range_start IS NULL)
      AND (o.order_date <= :order_date_range_end OR :order_date_range_end IS NULL)
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
    HAVING (SUM(o.total_amount) >= :min_total_spent OR :min_total_spent IS NULL)
       AND (SUM(o.total_amount) <= :max_total_spent OR :max_total_spent IS NULL)
)
SELECT
    customer_customer_id,
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_total_spent,
    RANK() OVER (ORDER BY customer_total_spent DESC) AS customer_rank
FROM databricks.customer_totals
ORDER BY customer_rank
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
