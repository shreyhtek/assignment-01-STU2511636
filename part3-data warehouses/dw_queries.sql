-- Q1: Total sales revenue by product category for each month
--
-- Joins fact_sales → dim_product (category) and dim_date (month/year).
-- Uses net_revenue since that is the post-discount amount actually earned.
-- Ordered chronologically; within each month highest revenue category first.
-- ============================================================
SELECT
    dd.year,
    dd.month,
    dd.month_name,
    dp.category,
    SUM(fs.units_sold)    AS total_units_sold,
    SUM(fs.net_revenue)   AS total_revenue,
    SUM(fs.profit)        AS total_profit
FROM fact_sales   fs
JOIN dim_date     dd ON dd.date_id    = fs.date_id
JOIN dim_product  dp ON dp.product_id = fs.product_id
GROUP BY
    dd.year,
    dd.month,
    dd.month_name,
    dp.category
ORDER BY
    dd.year   ASC,
    dd.month  ASC,
    total_revenue DESC;


-- Q2: Top 2 performing stores by total revenue
--
-- Joins fact_sales → dim_store.
-- RANK() window function handles ties correctly: if two stores share
-- a rank both appear, rather than one being arbitrarily dropped.
-- ============================================================
SELECT
    store_rank,
    store_name,
    city,
    region,
    total_transactions,
    total_units_sold,
    ROUND(total_revenue, 2)  AS total_revenue,
    ROUND(total_profit, 2)   AS total_profit
FROM (
    SELECT
        ds.store_id,
        ds.store_name,
        ds.city,
        ds.region,
        COUNT(fs.sales_id)    AS total_transactions,
        SUM(fs.units_sold)    AS total_units_sold,
        SUM(fs.net_revenue)   AS total_revenue,
        SUM(fs.profit)        AS total_profit,
        RANK() OVER (ORDER BY SUM(fs.net_revenue) DESC) AS store_rank
    FROM fact_sales fs
    JOIN dim_store  ds ON ds.store_id = fs.store_id
    GROUP BY
        ds.store_id,
        ds.store_name,
        ds.city,
        ds.region
) ranked
WHERE store_rank <= 2
ORDER BY store_rank;


-- Q3: Month-over-month sales trend across all stores
--
-- CTE sums net_revenue per month across all stores.
-- LAG() pulls the previous month's total into the current row.
-- NULLIF prevents division-by-zero for the first month (no prior month).
-- ============================================================
WITH monthly_totals AS (
    SELECT
        dd.year,
        dd.month,
        dd.month_name,
        SUM(fs.net_revenue) AS monthly_revenue,
        SUM(fs.units_sold)  AS monthly_units
    FROM fact_sales fs
    JOIN dim_date   dd ON dd.date_id = fs.date_id
    GROUP BY
        dd.year,
        dd.month,
        dd.month_name
)
SELECT
    year,
    month,
    month_name,
    ROUND(monthly_revenue, 2)  AS revenue,
    monthly_units,
    ROUND(
        LAG(monthly_revenue) OVER (ORDER BY year, month),
        2
    )                          AS prev_month_revenue,
    ROUND(
        monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year, month),
        2
    )                          AS revenue_change,
    ROUND(
        (
            (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year, month))
            / NULLIF(LAG(monthly_revenue) OVER (ORDER BY year, month), 0)
        ) * 100,
        2
    )                          AS pct_change
FROM monthly_totals
ORDER BY year, month;
