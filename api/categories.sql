-- @param category_id Filter by category ID.
-- @type category_id integer
-- @default category_id null

-- @param category_name Filter by category name (partial match).
-- @type category_name varchar
-- @default category_name null

-- @param category_description Filter by category description (partial match).
-- @type category_description varchar
-- @default category_description null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of categories matching the specified filters with pagination.

WITH filtered_categories AS (
    SELECT
        category_id AS category_category_id,
        category_name AS category_category_name,
        description AS category_description
    FROM databricks.categories
    WHERE (category_id = :category_id OR :category_id IS NULL)
      AND (category_name ILIKE CONCAT('%', :category_name, '%') OR :category_name IS NULL)
      AND (description ILIKE CONCAT('%', :category_description, '%') OR :category_description IS NULL)
)
SELECT *
FROM filtered_categories
ORDER BY category_category_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
