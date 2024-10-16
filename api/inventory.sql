-- @param inventory_id Filter by inventory ID.
-- @type inventory_id integer
-- @default inventory_id null

-- @param inventory_product_id Filter by product ID.
-- @type inventory_product_id integer
-- @default inventory_product_id null

-- @param inventory_quantity_in_stock_range_start Filter records with quantity in stock greater than or equal to this value.
-- @type inventory_quantity_in_stock_range_start integer
-- @default inventory_quantity_in_stock_range_start null

-- @param inventory_quantity_in_stock_range_end Filter records with quantity in stock less than or equal to this value.
-- @type inventory_quantity_in_stock_range_end integer
-- @default inventory_quantity_in_stock_range_end null

-- @param inventory_last_updated_range_start Filter records last updated on or after this date (YYYY-MM-DD).
-- @type inventory_last_updated_range_start date
-- @default inventory_last_updated_range_start null

-- @param inventory_last_updated_range_end Filter records last updated on or before this date (YYYY-MM-DD).
-- @type inventory_last_updated_range_end date
-- @default inventory_last_updated_range_end null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of inventory records matching the specified filters with pagination.

WITH filtered_inventory AS (
    SELECT
        inventory_id AS inventory_inventory_id,
        product_id AS inventory_product_id,
        quantity_in_stock AS inventory_quantity_in_stock,
        last_updated AS inventory_last_updated
    FROM inventory
    WHERE (inventory_id = :inventory_id OR :inventory_id IS NULL)
      AND (product_id = :inventory_product_id OR :inventory_product_id IS NULL)
      AND (quantity_in_stock >= :inventory_quantity_in_stock_range_start OR :inventory_quantity_in_stock_range_start IS NULL)
      AND (quantity_in_stock <= :inventory_quantity_in_stock_range_end OR :inventory_quantity_in_stock_range_end IS NULL)
      AND (last_updated >= :inventory_last_updated_range_start OR :inventory_last_updated_range_start IS NULL)
      AND (last_updated <= :inventory_last_updated_range_end OR :inventory_last_updated_range_end IS NULL)
)
SELECT *
FROM filtered_inventory
ORDER BY inventory_inventory_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
