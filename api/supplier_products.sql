-- @param supplier_id Filter by supplier ID.
-- @type supplier_id integer
-- @default supplier_id null

-- @param supplier_name Filter by supplier name (partial match).
-- @type supplier_name varchar
-- @default supplier_name null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param category_name Filter by category name (partial match).
-- @type category_name varchar
-- @default category_name null

-- @return A list of suppliers with their products, filtered by specified criteria.

WITH supplier_products AS (
    SELECT
        s.supplier_id AS supplier_supplier_id,
        s.supplier_name AS supplier_supplier_name,
        s.contact_name AS supplier_contact_name,
        s.contact_email AS supplier_contact_email,
        p.product_id AS product_product_id,
        p.product_name AS product_product_name,
        p.price AS product_price,
        c.category_name AS category_category_name
    FROM suppliers s
    JOIN products p ON s.supplier_id = p.supplier_id
    JOIN categories c ON p.category_id = c.category_id
    WHERE (s.supplier_id = :supplier_id OR :supplier_id IS NULL)
      AND (s.supplier_name ILIKE CONCAT('%', :supplier_name, '%') OR :supplier_name IS NULL)
      AND (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
      AND (c.category_name ILIKE CONCAT('%', :category_name, '%') OR :category_name IS NULL)
)
SELECT *
FROM supplier_products
ORDER BY supplier_supplier_id, product_product_id;
