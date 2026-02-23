
COPY olist.abc_analysis
TO 'Ruta/../output/abc_analysis.csv' CSV HEADER;

COPY olist.lead_time_analysis
TO 'Ruta/../output/lead_time_analysis.csv' CSV HEADER;

COPY olist.safety_stock
TO 'Ruta/../output/safety_stock.csv' CSV HEADER;

COPY olist.routes_analysis
TO 'Ruta/../output/routes_analysis.csv' CSV HEADER;

COPY olist.monthly_otif
TO 'Ruta/../output/monthly_otif.csv' CSV HEADER;

COPY olist.risk_summary
TO 'Ruta/../output/risk_summary.csv' CSV HEADER;


