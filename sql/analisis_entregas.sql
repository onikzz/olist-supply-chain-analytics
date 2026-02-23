--Creacion tabla analisis abc
CREATE TABLE olist.abc_analysis AS
WITH revenue_base AS (
    SELECT 
        COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
        ROUND(SUM(oi.price)::DECIMAL, 2) AS total_revenue,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        ROUND(AVG(oi.price)::DECIMAL, 2) AS avg_price,
        ROUND(SUM(oi.freight_value)::DECIMAL, 2) AS total_freight
    FROM olist.order_items oi
    JOIN olist.products p 
        ON oi.product_id = p.product_id
    JOIN olist.orders_delivered od 
        ON oi.order_id = od.order_id
    LEFT JOIN olist.category_translation ct 
        ON p.product_category_name = ct.product_category_name
    GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name)
),
revenue_with_cumulative AS (
    SELECT *,
        ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) AS pct_revenue,
        ROUND(SUM(total_revenue) OVER (ORDER BY total_revenue DESC ROWS UNBOUNDED PRECEDING)/ SUM(total_revenue) OVER () * 100, 2) AS cumulative_pct
    FROM revenue_base
)
SELECT *,
    CASE 
        WHEN cumulative_pct <= 80 THEN 'A'
        WHEN cumulative_pct <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_category
FROM revenue_with_cumulative
ORDER BY total_revenue DESC;


-- Comprobamos tabla
SELECT 
    abc_category,
    COUNT(*) AS num_categorias,
    ROUND(SUM(total_revenue), 2) AS revenue_total,
    ROUND(SUM(total_revenue) / SUM(SUM(total_revenue)) OVER () * 100, 2) AS pct_revenue
FROM olist.abc_analysis
GROUP BY abc_category
ORDER BY abc_category;

SELECT category, abc_category, total_revenue, pct_revenue, cumulative_pct
FROM olist.abc_analysis
LIMIT 10;


-- Analisis entregas 
CREATE TABLE olist.lead_time_analysis AS
SELECT 
    od.order_id,
    od.order_purchase_timestamp,
    od.order_delivered_customer_date,
    od.order_estimated_delivery_date,
    COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
    c.customer_state,
    s.seller_state,
	EXTRACT(DAY FROM od.order_delivered_customer_date - od.order_purchase_timestamp)::INT AS actual_lead_time,
    EXTRACT(DAY FROM od.order_estimated_delivery_date - od.order_purchase_timestamp)::INT AS scheduled_lead_time,
	EXTRACT(DAY FROM od.order_delivered_customer_date - od.order_estimated_delivery_date )::INT AS delivery_error,
    CASE 
        WHEN od.order_delivered_customer_date <= od.order_estimated_delivery_date 
        THEN 1 ELSE 0 
    END AS on_time,
	oi.price,
    oi.freight_value,
    EXTRACT(YEAR FROM od.order_purchase_timestamp)::INT  AS order_year,
    EXTRACT(MONTH FROM od.order_purchase_timestamp)::INT AS order_month
FROM olist.orders_delivered od
JOIN olist.order_items oi 
    ON od.order_id = oi.order_id
JOIN olist.products p 
    ON oi.product_id = p.product_id
JOIN olist.customers c 
    ON od.customer_id = c.customer_id
JOIN olist.sellers s 
    ON oi.seller_id = s.seller_id
LEFT JOIN olist.category_translation ct 
    ON p.product_category_name = ct.product_category_name;

-- kpi otif - on time in full, en tiempo y forma

SELECT 
    COUNT(*) AS total_orders,
    SUM(on_time) AS on_time_orders,
    COUNT(*) - SUM(on_time) AS late_orders,
    ROUND(SUM(on_time)::DECIMAL / COUNT(*) * 100, 2) AS otif_pct,
    ROUND(AVG(actual_lead_time), 1) AS avg_actual_days,
    ROUND(AVG(scheduled_lead_time), 1) AS avg_scheduled_days,
    ROUND(AVG(delivery_error), 1) AS avg_error_days
FROM olist.lead_time_analysis;

-- otif por categoria junto abc
SELECT 
    lt.category,
    abc.abc_category,
    ROUND(abc.total_revenue, 2) AS total_revenue,
    COUNT(*) AS total_orders,
    ROUND(AVG(lt.actual_lead_time), 1) AS avg_actual_days,
    ROUND(AVG(lt.scheduled_lead_time), 1) AS avg_scheduled_days,
    ROUND(AVG(lt.delivery_error), 1) AS avg_delay,
    ROUND(SUM(lt.on_time)::DECIMAL / COUNT(*) * 100, 2) AS otif_pct,
    CASE 
        WHEN abc.abc_category = 'A' 
            AND ROUND(SUM(lt.on_time)::DECIMAL / COUNT(*) * 100, 2) < 85 
            THEN 'CRITICO'
        WHEN abc.abc_category = 'A' 
            AND ROUND(SUM(lt.on_time)::DECIMAL / COUNT(*) * 100, 2) < 92 
            THEN 'ALTO'
        WHEN abc.abc_category = 'B' 
            AND ROUND(SUM(lt.on_time)::DECIMAL / COUNT(*) * 100, 2) < 85 
            THEN 'MEDIO'
        ELSE 'BAJO'
    END AS risk_level
FROM olist.lead_time_analysis lt
JOIN olist.abc_analysis abc ON lt.category = abc.category
GROUP BY lt.category, abc.abc_category, abc.total_revenue
ORDER BY abc.abc_category, otif_pct ASC;


-- Rutas problematicas

CREATE TABLE olist.routes_analysis AS
SELECT 
    seller_state,
    customer_state,
    COUNT(*)                                                    AS total_orders,
    ROUND(AVG(actual_lead_time), 1)                             AS avg_actual_days,
    ROUND(AVG(delivery_error), 1)                               AS avg_delay_days,
    ROUND(SUM(on_time)::DECIMAL / COUNT(*) * 100, 2)            AS otif_pct
FROM olist.lead_time_analysis
GROUP BY seller_state, customer_state
HAVING COUNT(*) >= 30
ORDER BY avg_delay_days DESC;

SELECT * FROM olist.routes_analysis;

-- Power bi

CREATE TABLE olist.monthly_otif AS
SELECT 
    order_year,
    order_month,
    TO_DATE(order_year || '-' || LPAD(order_month::TEXT, 2, '0') || '-01', 'YYYY-MM-DD') AS month_date,
    COUNT(*)                                                    AS total_orders,
    ROUND(SUM(on_time)::DECIMAL / COUNT(*) * 100, 2)            AS otif_pct,
    ROUND(AVG(actual_lead_time), 1)                             AS avg_lead_time,
    ROUND(AVG(delivery_error), 1)                               AS avg_delay
FROM olist.lead_time_analysis
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

SELECT * FROM olist.monthly_otif ORDER BY month_date;
