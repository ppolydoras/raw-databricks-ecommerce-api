-- @param year Include sales data for this year (YYYY).
-- @type year integer
-- @default year null

-- @param start_month Include sales data from this month onwards (1-12).
-- @type start_month integer
-- @default start_month null

-- @param end_month Include sales data up to this month (1-12).
-- @type end_month integer
-- @default end_month null

-- @return Monthly sales totals for the specified year.

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    SUM(total_amount) AS sales_total_amount
FROM orders
WHERE (DATE_PART('year', order_date) = :year OR :year IS NULL)
  AND (DATE_PART('month', order_date) >= :start_month OR :start_month IS NULL)
  AND (DATE_PART('month', order_date) <= :end_month OR :end_month IS NULL)
GROUP BY sales_month
ORDER BY sales_month;
