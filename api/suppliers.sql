-- @param supplier_id Filter by supplier ID.
-- @type supplier_id integer
-- @default supplier_id null

-- @param supplier_name Filter by supplier name (partial match).
-- @type supplier_name varchar
-- @default supplier_name null

-- @param supplier_contact_name Filter by contact name (partial match).
-- @type supplier_contact_name varchar
-- @default supplier_contact_name null

-- @param supplier_contact_email Filter by contact email (partial match).
-- @type supplier_contact_email varchar
-- @default supplier_contact_email null

-- @param supplier_phone Filter by supplier phone number (partial match).
-- @type supplier_phone varchar
-- @default supplier_phone null

-- @param supplier_address Filter by supplier address (partial match).
-- @type supplier_address varchar
-- @default supplier_address null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of suppliers matching the specified filters with pagination.

WITH filtered_suppliers AS (
    SELECT
        supplier_id AS supplier_supplier_id,
        supplier_name AS supplier_supplier_name,
        contact_name AS supplier_contact_name,
        contact_email AS supplier_contact_email,
        phone AS supplier_phone,
        address AS supplier_address
    FROM databricks.suppliers
    WHERE (supplier_id = :supplier_id OR :supplier_id IS NULL)
      AND (supplier_name ILIKE CONCAT('%', :supplier_name, '%') OR :supplier_name IS NULL)
      AND (contact_name ILIKE CONCAT('%', :supplier_contact_name, '%') OR :supplier_contact_name IS NULL)
      AND (contact_email ILIKE CONCAT('%', :supplier_contact_email, '%') OR :supplier_contact_email IS NULL)
      AND (phone ILIKE CONCAT('%', :supplier_phone, '%') OR :supplier_phone IS NULL)
      AND (address ILIKE CONCAT('%', :supplier_address, '%') OR :supplier_address IS NULL)
)
SELECT *
FROM databricks.filtered_suppliers
ORDER BY supplier_supplier_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
