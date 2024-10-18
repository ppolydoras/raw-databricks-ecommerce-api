-- @param product_id Filter by product ID.
-- @type product_id integer
-- @default product_id null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param category_name Filter by category name (partial match).
-- @type category_name varchar
-- @default category_name null

-- @param supplier_name Filter by supplier name (partial match).
-- @type supplier_name varchar
-- @default supplier_name null

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

-- @return A list of products with category and supplier details matching the specified filters with pagination.

WITH products_with_details AS (
    SELECT
        p.product_id AS product_product_id,
        p.product_name AS product_product_name,
        p.price AS product_price,
        p.description AS product_description,
        c.category_id AS category_category_id,
        c.category_name AS category_category_name,
        c.description AS category_description,
        s.supplier_id AS supplier_supplier_id,
        s.supplier_name AS supplier_supplier_name,
        s.contact_name AS supplier_contact_name,
        s.contact_email AS supplier_contact_email
    FROM databricks.products p
    JOIN databricks.categories c ON p.category_id = c.category_id
    JOIN databricks.suppliers s ON p.supplier_id = s.supplier_id
    WHERE (p.product_id = :product_id OR :product_id IS NULL)
      AND (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
      AND (c.category_name ILIKE CONCAT('%', :category_name, '%') OR :category_name IS NULL)
      AND (s.supplier_name ILIKE CONCAT('%', :supplier_name, '%') OR :supplier_name IS NULL)
      AND (p.price >= :product_price_range_start OR :product_price_range_start IS NULL)
      AND (p.price <= :product_price_range_end OR :product_price_range_end IS NULL)
)
SELECT *
FROM databricks.products_with_details
ORDER BY product_product_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
