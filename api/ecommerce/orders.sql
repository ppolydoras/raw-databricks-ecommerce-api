-- @param order_id Filter by order ID.
-- @type order_id integer
-- @default order_id null

-- @param order_customer_id Filter by customer ID.
-- @type order_customer_id integer
-- @default order_customer_id null

-- @param order_status Filter by order status (e.g., 'Processing', 'Shipped').
-- @type order_status varchar
-- @default order_status null

-- @param order_date_range_start Filter orders placed on or after this date (YYYY-MM-DD).
-- @type order_date_range_start date
-- @default order_date_range_start null

-- @param order_date_range_end Filter orders placed on or before this date (YYYY-MM-DD).
-- @type order_date_range_end date
-- @default order_date_range_end null

-- @param order_total_amount_range_start Filter orders with total amount greater than or equal to this value.
-- @type order_total_amount_range_start decimal
-- @default order_total_amount_range_start null

-- @param order_total_amount_range_end Filter orders with total amount less than or equal to this value.
-- @type order_total_amount_range_end decimal
-- @default order_total_amount_range_end null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of orders matching the specified filters with pagination.

WITH filtered_orders AS (
    SELECT
        order_id AS order_order_id,
        customer_id AS order_customer_id,
        order_date AS order_order_date,
        status AS order_status,
        total_amount AS order_total_amount
    FROM databricks.orders
    WHERE (order_id = :order_id OR :order_id IS NULL)
      AND (customer_id = :order_customer_id OR :order_customer_id IS NULL)
      AND (status ILIKE :order_status OR :order_status IS NULL)
      AND (order_date >= :order_date_range_start OR :order_date_range_start IS NULL)
      AND (order_date <= :order_date_range_end OR :order_date_range_end IS NULL)
      AND (total_amount >= :order_total_amount_range_start OR :order_total_amount_range_start IS NULL)
      AND (total_amount <= :order_total_amount_range_end OR :order_total_amount_range_end IS NULL)
)
SELECT *
FROM filtered_orders
ORDER BY order_order_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
