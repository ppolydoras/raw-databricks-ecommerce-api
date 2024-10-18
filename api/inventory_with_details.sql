-- @param inventory_product_id Filter by product ID.
-- @type inventory_product_id integer
-- @default inventory_product_id null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param category_name Filter by category name (partial match).
-- @type category_name varchar
-- @default category_name null

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

-- @return A list of inventory records with product details matching the specified filters.
WITH inventory_with_details AS (
    SELECT
        i.inventory_id AS inventory_inventory_id,
        i.product_id AS inventory_product_id,
        i.quantity_in_stock AS inventory_quantity_in_stock,
        i.last_updated AS inventory_last_updated,
        p.product_name AS product_product_name,
        c.category_name AS category_category_name,
        s.supplier_name AS supplier_supplier_name
    FROM databricks.inventory i
    JOIN databricks.products p ON i.product_id = p.product_id
    JOIN databricks.categories c ON p.category_id = c.category_id
    JOIN databricks.suppliers s ON p.supplier_id = s.supplier_id
    WHERE (i.product_id = :inventory_product_id OR :inventory_product_id IS NULL)
      AND (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
      AND (c.category_name ILIKE CONCAT('%', :category_name, '%') OR :category_name IS NULL)
      AND (i.quantity_in_stock >= :inventory_quantity_in_stock_range_start OR :inventory_quantity_in_stock_range_start IS NULL)
      AND (i.quantity_in_stock <= :inventory_quantity_in_stock_range_end OR :inventory_quantity_in_stock_range_end IS NULL)
      AND (i.last_updated >= :inventory_last_updated_range_start OR :inventory_last_updated_range_start IS NULL)
      AND (i.last_updated <= :inventory_last_updated_range_end OR :inventory_last_updated_range_end IS NULL)
)
SELECT *
FROM inventory_with_details
ORDER BY inventory_inventory_id;
