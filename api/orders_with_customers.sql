-- @param order_id Filter by order ID.
-- @type order_id integer
-- @default order_id null

-- @param order_customer_id Filter by customer ID.
-- @type order_customer_id integer
-- @default order_customer_id null

-- @param customer_first_name Filter by customer's first name (partial match).
-- @type customer_first_name varchar
-- @default customer_first_name null

-- @param customer_last_name Filter by customer's last name (partial match).
-- @type customer_last_name varchar
-- @default customer_last_name null

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

-- @return A list of orders with customer details matching the specified filters with pagination.

WITH orders_with_customers AS (
    SELECT
        o.order_id AS order_order_id,
        o.customer_id AS order_customer_id,
        o.order_date AS order_order_date,
        o.status AS order_status,
        o.total_amount AS order_total_amount,
        c.first_name AS customer_first_name,
        c.last_name AS customer_last_name,
        c.email AS customer_email,
        c.phone AS customer_phone,
        c.address AS customer_address,
        c.city AS customer_city,
        c.state AS customer_state,
        c.zip_code AS customer_zip_code,
        c.registration_date AS customer_registration_date
    FROM databricks.orders o
    JOIN databricks.customers c ON o.customer_id = c.customer_id
    WHERE (o.order_id = :order_id OR :order_id IS NULL)
      AND (o.customer_id = :order_customer_id OR :order_customer_id IS NULL)
      AND (c.first_name ILIKE CONCAT('%', :customer_first_name, '%') OR :customer_first_name IS NULL)
      AND (c.last_name ILIKE CONCAT('%', :customer_last_name, '%') OR :customer_last_name IS NULL)
      AND (o.status ILIKE :order_status OR :order_status IS NULL)
      AND (o.order_date >= :order_date_range_start OR :order_date_range_start IS NULL)
      AND (o.order_date <= :order_date_range_end OR :order_date_range_end IS NULL)
      AND (o.total_amount >= :order_total_amount_range_start OR :order_total_amount_range_start IS NULL)
      AND (o.total_amount <= :order_total_amount_range_end OR :order_total_amount_range_end IS NULL)
)
SELECT *
FROM databricks.orders_with_customers
ORDER BY order_order_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
