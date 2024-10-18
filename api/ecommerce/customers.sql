-- @param customer_id Filter by customer ID.
-- @type customer_id integer
-- @default customer_id null

-- @param customer_first_name Filter by customer's first name (partial match).
-- @type customer_first_name varchar
-- @default customer_first_name null

-- @param customer_last_name Filter by customer's last name (partial match).
-- @type customer_last_name varchar
-- @default customer_last_name null

-- @param customer_email Filter by customer's email (partial match).
-- @type customer_email varchar
-- @default customer_email null

-- @param customer_phone Filter by customer's phone number (partial match).
-- @type customer_phone varchar
-- @default customer_phone null

-- @param customer_address Filter by customer's address (partial match).
-- @type customer_address varchar
-- @default customer_address null

-- @param customer_city Filter by customer's city (partial match).
-- @type customer_city varchar
-- @default customer_city null

-- @param customer_state Filter by customer's state (partial match).
-- @type customer_state varchar
-- @default customer_state null

-- @param customer_zip_code Filter by customer's zip code.
-- @type customer_zip_code varchar
-- @default customer_zip_code null

-- @param customer_registration_date_range_start Filter customers registered on or after this date (YYYY-MM-DD).
-- @type customer_registration_date_range_start date
-- @default customer_registration_date_range_start null

-- @param customer_registration_date_range_end Filter customers registered on or before this date (YYYY-MM-DD).
-- @type customer_registration_date_range_end date
-- @default customer_registration_date_range_end null

-- @param page The current page number to retrieve.
-- @type page integer
-- @default page 1

-- @param page_size The number of records per page. Default value is 25.
-- @type page_size integer
-- @default page_size 25

-- @return A list of customers matching the specified filters with pagination.

WITH filtered_customers AS (
    SELECT
        customer_id AS customer_customer_id,
        first_name AS customer_first_name,
        last_name AS customer_last_name,
        email AS customer_email,
        phone AS customer_phone,
        address AS customer_address,
        city AS customer_city,
        state AS customer_state,
        zip_code AS customer_zip_code,
        registration_date AS customer_registration_date
    FROM databricks.customers
    WHERE (customer_id = :customer_id OR :customer_id IS NULL)
      AND (first_name ILIKE CONCAT('%', :customer_first_name, '%') OR :customer_first_name IS NULL)
      AND (last_name ILIKE CONCAT('%', :customer_last_name, '%') OR :customer_last_name IS NULL)
      AND (email ILIKE CONCAT('%', :customer_email, '%') OR :customer_email IS NULL)
      AND (phone ILIKE CONCAT('%', :customer_phone, '%') OR :customer_phone IS NULL)
      AND (address ILIKE CONCAT('%', :customer_address, '%') OR :customer_address IS NULL)
      AND (city ILIKE CONCAT('%', :customer_city, '%') OR :customer_city IS NULL)
      AND (state ILIKE CONCAT('%', :customer_state, '%') OR :customer_state IS NULL)
      AND (zip_code = :customer_zip_code OR :customer_zip_code IS NULL)
      AND (registration_date >= :customer_registration_date_range_start OR :customer_registration_date_range_start IS NULL)
      AND (registration_date <= :customer_registration_date_range_end OR :customer_registration_date_range_end IS NULL)
)
SELECT *
FROM filtered_customers
ORDER BY customer_customer_id
LIMIT COALESCE(:page_size, 25) OFFSET (COALESCE(:page, 1) - 1) * COALESCE(:page_size, 25);
 
