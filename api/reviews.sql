-- @param review_id Filter by review ID.
-- @type review_id integer
-- @default review_id null

-- @param review_product_id Filter by product ID.
-- @type review_product_id integer
-- @default review_product_id null

-- @param review_customer_id Filter by customer ID.
-- @type review_customer_id integer
-- @default review_customer_id null

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

-- @return A list of reviews matching the specified filters with pagination.

WITH filtered_reviews AS (
    SELECT
        review_id AS review_review_id,
        product_id AS review_product_id,
        customer_id AS review_customer_id,
        rating AS review_rating,
        review_text AS review_review_text,
        review_date AS review_review_date
    FROM reviews
    WHERE (review_id = :review_id OR :review_id IS NULL)
      AND (product_id = :review_product_id OR :review_product_id IS NULL)
      AND (customer_id = :review_customer_id OR :review_customer_id IS NULL)
      AND (rating = :review_rating OR :review_rating IS NULL)
      AND (review_date >= :review_date_range_start OR :review_date_range_start IS NULL)
      AND (review_date <= :review_date_range_end OR :review_date_range_end IS NULL)
)
SELECT *
FROM filtered_reviews
ORDER BY review_review_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
