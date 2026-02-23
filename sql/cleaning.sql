-- Estados de ordenes
SELECT 
    order_status, 
    COUNT(*) AS total,
    ROUND(COUNT(*)::DECIMAL / SUM(COUNT(*)) OVER () * 100, 2) AS pct
FROM olist.orders
GROUP BY order_status
ORDER BY total DESC;

-- Nulos importantes
SELECT 
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS nulos_approved,
    COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NULL) AS nulos_carrier,
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS nulos_delivered,
    COUNT(*) FILTER (WHERE order_status = 'delivered') AS total_delivered
FROM olist.orders;

SELECT 
    COUNT(*) AS total_products,
    COUNT(*) FILTER (WHERE product_category_name IS NULL) AS nulos_categoria,
    COUNT(*) FILTER (WHERE product_weight_g IS NULL) AS nulos_peso
FROM olist.products;

UPDATE olist.products
SET product_category_name = 'sin_categoria'
WHERE product_category_name IS NULL;

-- Vista para Ordenes entregadadas con datos completos
CREATE VIEW olist.orders_delivered AS
SELECT 
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist.orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_purchase_timestamp IS NOT NULL;

