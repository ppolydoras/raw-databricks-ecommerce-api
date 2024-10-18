-- @param order_item_id Filter by order item ID.
-- @type order_item_id integer
-- @default order_item_id null

-- @param order_item_order_id Filter by order ID.
-- @type order_item_order_id integer
-- @default order_item_order_id null

-- @param order_item_product_id Filter by product ID.
-- @type order_item_product_id integer
-- @default order_item_product_id null

-- @param order_item_quantity_range_start Filter order items with quantity greater than or equal to this value.
-- @type order_item_quantity_range_start integer
-- @default order_item_quantity_range_start null

-- @param order_item_quantity_range_end Filter order items with quantity less than or equal to this value.
-- @type order_item_quantity_range_end integer
-- @default order_item_quantity_range_end null

-- @param order_item_unit_price_range_start Filter order items with unit price greater than or equal to this value.
-- @type order_item_unit_price_range_start decimal
-- @default order_item_unit_price_range_start null

-- @param order_item_unit_price_range_end Filter order items with unit price less than or equal to this value.
-- @type order_item_unit_price_range_end decimal
-- @default order_item_unit_price_range_end null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of order items matching the specified filters with pagination.

WITH filtered_order_items AS (
    SELECT
        order_item_id AS order_item_order_item_id,
        order_id AS order_item_order_id,
        product_id AS order_item_product_id,
        quantity AS order_item_quantity,
        unit_price AS order_item_unit_price
    FROM databricks.order_items
    WHERE (order_item_id = :order_item_id OR :order_item_id IS NULL)
      AND (order_id = :order_item_order_id OR :order_item_order_id IS NULL)
      AND (product_id = :order_item_product_id OR :order_item_product_id IS NULL)
      AND (quantity >= :order_item_quantity_range_start OR :order_item_quantity_range_start IS NULL)
      AND (quantity <= :order_item_quantity_range_end OR :order_item_quantity_range_end IS NULL)
      AND (unit_price >= :order_item_unit_price_range_start OR :order_item_unit_price_range_start IS NULL)
      AND (unit_price <= :order_item_unit_price_range_end OR :order_item_unit_price_range_end IS NULL)
)
SELECT *
FROM filtered_order_items
ORDER BY order_item_order_item_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
