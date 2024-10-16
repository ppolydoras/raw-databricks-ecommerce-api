-- @param product_id Filter by product ID.
-- @type product_id integer
-- @default product_id null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param product_category_id Filter by category ID.
-- @type product_category_id integer
-- @default product_category_id null

-- @param product_supplier_id Filter by supplier ID.
-- @type product_supplier_id integer
-- @default product_supplier_id null

-- @param product_price_range_start Filter products with price greater than or equal to this value.
-- @type product_price_range_start decimal
-- @default product_price_range_start null

-- @param product_price_range_end Filter products with price less than or equal to this value.
-- @type product_price_range_end decimal
-- @default product_price_range_end null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of products matching the specified filters with pagination.

WITH filtered_products AS (
    SELECT
        product_id AS product_product_id,
        product_name AS product_product_name,
        category_id AS product_category_id,
        supplier_id AS product_supplier_id,
        price AS product_price,
        description AS product_description
    FROM products
    WHERE (product_id = :product_id OR :product_id IS NULL)
      AND (product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
      AND (category_id = :product_category_id OR :product_category_id IS NULL)
      AND (supplier_id = :product_supplier_id OR :product_supplier_id IS NULL)
      AND (price >= :product_price_range_start OR :product_price_range_start IS NULL)
      AND (price <= :product_price_range_end OR :product_price_range_end IS NULL)
)
SELECT *
FROM filtered_products
ORDER BY product_product_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
