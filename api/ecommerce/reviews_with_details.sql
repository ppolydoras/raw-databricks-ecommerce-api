-- @param review_product_id Filter by product ID.
-- @type review_product_id integer
-- @default review_product_id null

-- @param review_customer_id Filter by customer ID.
-- @type review_customer_id integer
-- @default review_customer_id null

-- @param product_name Filter by product name (partial match).
-- @type product_name varchar
-- @default product_name null

-- @param customer_first_name Filter by customer's first name (partial match).
-- @type customer_first_name varchar
-- @default customer_first_name null

-- @param customer_last_name Filter by customer's last name (partial match).
-- @type customer_last_name varchar
-- @default customer_last_name null

-- @param review_rating Filter by rating (1-5).
-- @type review_rating integer
-- @default review_rating null

-- @param review_date_range_start Filter reviews submitted on or after this date (YYYY-MM-DD).
-- @type review_date_range_start date
-- @default review_date_range_start null

-- @param review_date_range_end Filter reviews submitted on or before this date (YYYY-MM-DD).
-- @type review_date_range_end date
-- @default review_date_range_end null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of reviews with customer and product details matching the specified filters with pagination.

WITH reviews_with_details AS (
    SELECT
        r.review_id AS review_review_id,
        r.product_id AS review_product_id,
        r.customer_id AS review_customer_id,
        r.rating AS review_rating,
        r.review_text AS review_review_text,
        r.review_date AS review_review_date,
        p.product_name AS product_product_name,
        c.first_name AS customer_first_name,
        c.last_name AS customer_last_name
    FROM databricks.reviews r
    JOIN databricks.products p ON r.product_id = p.product_id
    JOIN databricks.customers c ON r.customer_id = c.customer_id
    WHERE (r.product_id = :review_product_id OR :review_product_id IS NULL)
      AND (r.customer_id = :review_customer_id OR :review_customer_id IS NULL)
      AND (p.product_name ILIKE CONCAT('%', :product_name, '%') OR :product_name IS NULL)
      AND (c.first_name ILIKE CONCAT('%', :customer_first_name, '%') OR :customer_first_name IS NULL)
      AND (c.last_name ILIKE CONCAT('%', :customer_last_name, '%') OR :customer_last_name IS NULL)
      AND (r.rating = :review_rating OR :review_rating IS NULL)
      AND (r.review_date >= :review_date_range_start OR :review_date_range_start IS NULL)
      AND (r.review_date <= :review_date_range_end OR :review_date_range_end IS NULL)
)
SELECT *
FROM reviews_with_details
ORDER BY review_review_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
