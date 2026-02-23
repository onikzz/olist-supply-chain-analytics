CREATE TABLE olist.safety_stock AS
SELECT 
    lt.category,
    abc.abc_category,
    ROUND(abc.total_revenue, 2) AS total_revenue,
    MAX(lt.actual_lead_time) AS max_lead_time,
    ROUND(AVG(lt.actual_lead_time), 1) AS avg_lead_time,
    MIN(lt.actual_lead_time) AS min_lead_time,
    MAX(lt.price) AS max_price,
    ROUND(AVG(lt.price), 2) AS avg_price,

    -- Fórmula Safety Stock = (Max LT × Max Sales) - (Avg LT × Avg Sales)
    ROUND((MAX(lt.actual_lead_time) * MAX(lt.price)) - (AVG(lt.actual_lead_time) * AVG(lt.price)), 2) AS safety_stock_value,
	COUNT(*) AS total_orders,
    ROUND(SUM(lt.on_time)::DECIMAL / COUNT(*) * 100, 2) AS otif_pct

FROM olist.lead_time_analysis lt
JOIN olist.abc_analysis abc ON lt.category = abc.category
GROUP BY lt.category, abc.abc_category, abc.total_revenue;

-- Tabla de riesgo
CREATE TABLE olist.risk_summary AS
SELECT 
    category,
    abc_category,
    total_revenue,
    safety_stock_value,
    otif_pct,
    avg_lead_time,
    total_orders,
    CASE 
        WHEN abc_category = 'A' AND otif_pct < 85  THEN 'RIESGO CRITICO'
        WHEN abc_category = 'A' AND otif_pct < 92  THEN 'RIESGO ALTO'
        WHEN abc_category = 'B' AND otif_pct < 85  THEN 'RIESGO MEDIO'
        WHEN abc_category = 'C' AND safety_stock_value > 50000 THEN 'OVERSTOCK'
        ELSE 'RIESGO BAJO'
    END AS risk_level
FROM olist.safety_stock
ORDER BY 
    CASE abc_category WHEN 'A' THEN 1 WHEN 'B' THEN 2 ELSE 3 END,
    otif_pct ASC;

-- Resumen de riesgos
SELECT risk_level, COUNT(*) AS categorias, ROUND(SUM(total_revenue), 2) AS revenue
FROM olist.risk_summary
GROUP BY risk_level
ORDER BY categorias DESC;