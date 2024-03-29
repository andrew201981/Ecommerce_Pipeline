-- TODO: This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. The first column 
-- will be Category, that will contain the top 10 least revenue categories; the 
-- second one will be Num_order, with the total amount of orders of each 
-- category; and the last one will be Revenue, with the total revenue of each 
-- catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.
WITH CategoryRevenue AS (
    SELECT
        t.product_category_name_english AS Category,
        COUNT(DISTINCT o.order_id) AS Num_order,
        SUM(op.payment_value) AS Revenue
    FROM olist_orders o
    JOIN olist_order_payments op ON o.order_id = op.order_id
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    JOIN olist_products p ON oi.product_id = p.product_id
    JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
        AND p.product_category_name IS NOT NULL
        AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY t.product_category_name_english
)
SELECT
    Category,
    Num_order,
    Revenue
FROM CategoryRevenue
ORDER BY Revenue ASC
LIMIT 10;