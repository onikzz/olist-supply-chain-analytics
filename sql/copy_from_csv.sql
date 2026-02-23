COPY olist.orders
FROM 'Ruta/../olist_orders_dataset.csv'
DELIMITER ',' CSV HEADER;

COPY olist.order_items
FROM 'Ruta/../olist_order_items_dataset.csv'
DELIMITER ',' CSV HEADER;

COPY olist.products
FROM 'Ruta/../olist_products_dataset.csv'
DELIMITER ',' CSV HEADER;

COPY olist.customers
FROM 'Ruta/../Olist_supChain\olist_customers_dataset.csv'
DELIMITER ',' CSV HEADER;

COPY olist.sellers
FROM 'Ruta/../olist_sellers_dataset.csv'
DELIMITER ',' CSV HEADER;

COPY olist.order_payments
FROM 'Ruta/../olist_order_payments_dataset.csv'
DELIMITER ',' CSV HEADER;

COPY olist.order_reviews
FROM 'Ruta/../olist_order_reviews_dataset.csv'
DELIMITER ',' CSV HEADER;

COPY olist.category_translation
FROM 'Ruta/../product_category_name_translation.csv'
DELIMITER ',' CSV HEADER;

