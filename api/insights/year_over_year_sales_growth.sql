-- @param start_year Include sales data from this year onwards (YYYY).
-- @type start_year integer
-- @default start_year null

-- @param end_year Include sales data up to this year (YYYY).
-- @type end_year integer
-- @default end_year null

-- @return Yearly sales totals with year-over-year growth percentage.

WITH yearly_sales AS (
    SELECT
        DATE_PART('year', order_date) AS sales_year,
        SUM(total_amount) AS sales_total_amount
    FROM databricks.orders
    WHERE (DATE_PART('year', order_date) >= :start_year OR :start_year IS NULL)
      AND (DATE_PART('year', order_date) <= :end_year OR :end_year IS NULL)
    GROUP BY sales_year
),
growth_calculation AS (
    SELECT
        ys.sales_year AS sales_sales_year,
        ys.sales_total_amount AS sales_total_amount,
        LAG(ys.sales_total_amount) OVER (ORDER BY ys.sales_year) AS sales_previous_year_amount,
        CASE
            WHEN LAG(ys.sales_total_amount) OVER (ORDER BY ys.sales_year) IS NOT NULL THEN
                ((ys.sales_total_amount - LAG(ys.sales_total_amount) OVER (ORDER BY ys.sales_year)) / LAG(ys.sales_total_amount) OVER (ORDER BY ys.sales_year)) * 100
            ELSE NULL
        END AS sales_growth_percentage
    FROM databricks.yearly_sales ys
)
SELECT *
FROM databricks.growth_calculation
ORDER BY sales_sales_year;
