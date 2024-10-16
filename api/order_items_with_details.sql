-- @param order_item_order_id Filter by order ID.
-- @type order_item_order_id integer
-- @default order_item_order_id null

-- @param order_item_product_id Filter by product ID.
-- @type order_item_product_id integer
-- @default order_item_product_id null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param order_date_range_start Filter orders placed on or after this date (YYYY-MM-DD).
-- @type order_date_range_start date
-- @default order_date_range_start null

-- @param order_date_range_end Filter orders placed on or before this date (YYYY-MM-DD).
-- @type order_date_range_end date
-- @default order_date_range_end null

-- @param order_status Filter by order status.
-- @type order_status varchar
-- @default order_status null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of order items with product and order details matching the specified filters with pagination.

WITH order_items_with_details AS (
    SELECT
        oi.order_item_id AS order_item_order_item_id,
        oi.order_id AS order_item_order_id,
        oi.product_id AS order_item_product_id,
        oi.quantity AS order_item_quantity,
        oi.unit_price AS order_item_unit_price,
        o.order_date AS order_order_date,
        o.status AS order_status,
        o.total_amount AS order_total_amount,
        p.product_name AS product_product_name,
        p.category_id AS product_category_id,
        p.supplier_id AS product_supplier_id,
        p.price AS product_price
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE (oi.order_id = :order_item_order_id OR :order_item_order_id IS NULL)
      AND (oi.product_id = :order_item_product_id OR :order_item_product_id IS NULL)
      AND (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
      AND (o.order_date >= :order_date_range_start OR :order_date_range_start IS NULL)
      AND (o.order_date <= :order_date_range_end OR :order_date_range_end IS NULL)
      AND (o.status ILIKE :order_status OR :order_status IS NULL)
)
SELECT *
FROM order_items_with_details
ORDER BY order_item_order_item_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
