

SELECT  *
FROM dbo.customer;
go

SELECT COUNT(*) AS total_rows
FROM dbo.customer;
go
SELECT TOP 5 *
FROM dbo.customer;
go
-- Total revenue generated from all purchases
SELECT SUM(purchase_amount_usd) AS total_revenue
FROM dbo.customer;
go
-- Average amount spent per transaction
SELECT ROUND(AVG(purchase_amount_usd), 2) AS avg_order_value
FROM dbo.customer;
go
-- Count of distinct customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM dbo.customer;
go
-- Identify top-performing product categories by revenue
SELECT category,
       SUM(purchase_amount_usd) AS category_revenue
FROM dbo.customer
GROUP BY category
ORDER BY category_revenue DESC;
go
-- Compare revenue contribution by gender
SELECT gender,
       SUM(purchase_amount_usd) AS revenue
FROM dbo.customer
GROUP BY gender;
go
-- Analyze which age groups contribute most to revenue
SELECT age_group,
       SUM(purchase_amount_usd) AS revenue
FROM dbo.customer
GROUP BY age_group
ORDER BY revenue DESC;
go
-- Compare spending behavior of subscribers and non-subscribers
SELECT subscription_status,
       COUNT(DISTINCT customer_id) AS customers,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_spend,
       SUM(purchase_amount_usd) AS total_revenue
FROM dbo.customer
GROUP BY subscription_status;
-- Analyze how shipping choice impacts spending
SELECT shipping_type,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase_amount
FROM dbo.customer
GROUP BY shipping_type;
-- Identify customers who use discounts but still spend above average
WITH avg_spend AS (
    SELECT AVG(purchase_amount_usd) AS avg_amount
    FROM dbo.customer
)
SELECT customer_id,
       purchase_amount_usd
FROM dbo.customer
WHERE discount_applied = 'Yes'
  AND purchase_amount_usd > (SELECT avg_amount FROM avg_spend);
  -- Identify products heavily dependent on discounts
SELECT item_purchased,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) AS discounted_orders,
       ROUND(
           SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
       ) AS discount_percentage
FROM dbo.customer
GROUP BY item_purchased
HAVING COUNT(*) > 30
ORDER BY discount_percentage DESC;
-- Segment customers based on purchase history
SELECT customer_id,
       SUM(previous_purchases) AS total_purchases,
       CASE
           WHEN SUM(previous_purchases) >= 10 THEN 'Loyal'
           WHEN SUM(previous_purchases) BETWEEN 5 AND 9 THEN 'Returning'
           ELSE 'New'
       END AS customer_segment
FROM dbo.customer
GROUP BY customer_id;
-- Calculate revenue contribution percentage by age group
SELECT age_group,
       SUM(purchase_amount_usd) AS revenue,
       ROUND(
           SUM(purchase_amount_usd) * 100.0 /
           SUM(SUM(purchase_amount_usd)) OVER (), 2
       ) AS revenue_percentage
FROM dbo.customer
GROUP BY age_group;

SELECT  *
FROM dbo.customer;












