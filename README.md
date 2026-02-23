# 🔗 Olist Supply Chain Analytics

End-to-end supply chain analysis using real Brazilian e-commerce data.  
Built with PostgreSQL, SQL (Window Functions, CTEs) and Power BI.

---

## 📌 Business Problem

In a marketplace like Olist, late deliveries generate returns, negative reviews and customer churn.  
This project identifies **which product categories generate the most revenue AND have the worst delivery performance**, crossing ABC Analysis with OTIF metrics to prioritize operational risk.

**Key finding:** Olist promises delivery in ~23 days on average but delivers in ~12 days.  
The operation is nearly **2x faster than what it promises to customers** — a direct competitive opportunity.

---

## 📊 Dataset

**Source:** [Olist Brazilian E-Commerce — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
**Period:** September 2016 — October 2018  
**Scope:** 96,478 delivered orders | $13.2M USD in revenue | 71 product categories

---

## 🔍 Key Findings

- **Total Revenue:** $13.2M USD
- **OTIF (On-Time In-Full):** 91.88%
- **Late Orders:** 7,834
- **Avg Real Lead Time:** 12.1 days
- **Avg Promised Lead Time:** 23.4 days
- **Avg Delivery Gap:** -11.9 days (arrives early)
- Top revenue categories: health_beauty ($1.23M), watches_gifts ($1.17M), bed_bath_table ($1.02M)
- ~20 of 71 categories (Class A) generate **80% of total revenue**
- Class A categories with OTIF below 92% represent the highest business risk

---

## 💡 Business Recommendations

1. **Reduce promised delivery time** — The real operation delivers in 12 days but promises 23. Updating estimates would make Olist significantly more competitive without any operational changes.
2. **Prioritize SLA agreements with sellers in high-delay states** — Routes with the highest average delay should have renegotiated service levels.
3. **Increase safety stock for Class A categories with OTIF below 85%** — These represent critical revenue at risk from operational failures.

---


---

## 🛠️ Tech Stack

- **PostgreSQL 18** — Database, schema design, analytical queries
- **SQL** — Window Functions, CTEs, aggregations, multi-table JOINs
- **Power BI** — Dashboard, DAX measures

---

## 📐 SQL Concepts Used

- **CTEs** for multi-step transformations
- **Window Functions** — `SUM() OVER()`, cumulative revenue for ABC classification
- **EXTRACT()** for date arithmetic and lead time calculation
- **COALESCE()** for null handling
- **CASE WHEN** for ABC classification and risk scoring
- **Multi-table JOINs** across 5+ tables

---

## 📬 Contact

**Diego Sánchez Reyes**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-diegoreyes982-blue)](https://www.linkedin.com/in/diegoreyes982/)  
📧 diegoreyes9821@gmail.com


----------------------------------------------------------------------------------------------


# 🔗 Olist Supply Chain Analytics

Análisis end-to-end de cadena de suministro usando datos reales de e-commerce brasileño.  
Construido con PostgreSQL, SQL (Window Functions, CTEs) y Power BI.

---

## 📌 Problema de Negocio

En un marketplace como Olist, los retrasos en entregas generan devoluciones, reseñas negativas y pérdida de clientes.  
Este proyecto identifica **qué categorías de productos generan más revenue Y tienen peor desempeño de entrega**, cruzando Análisis ABC con métricas OTIF para priorizar el riesgo operativo.

**Hallazgo clave:** Olist promete entrega en ~23 días en promedio pero entrega en ~12 días.  
La operación es casi **2 veces más rápida de lo que le promete a sus clientes** — una oportunidad competitiva directa.

---

## 📊 Dataset

**Fuente:** [Olist Brazilian E-Commerce — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
**Periodo:** Septiembre 2016 — Octubre 2018  
**Alcance:** 96,478 órdenes entregadas | $13.2M USD en revenue | 71 categorías de productos

---

## 🔍 Hallazgos Principales

- **Revenue Total:** $13.2M USD
- **OTIF (On-Time In-Full):** 91.88%
- **Órdenes Tardías:** 7,834
- **Lead Time Real Promedio:** 12.1 días
- **Lead Time Prometido Promedio:** 23.4 días
- **Brecha de Entrega Promedio:** -11.9 días (llega antes)
- Top categorías por revenue: health_beauty ($1.23M), watches_gifts ($1.17M), bed_bath_table ($1.02M)
- ~20 de 71 categorías (Clase A) generan el **80% del revenue total**
- Las categorías Clase A con OTIF por debajo del 92% representan el mayor riesgo de negocio

---

## 💡 Recomendaciones de Negocio

1. **Reducir el tiempo prometido de entrega** — La operación real entrega en 12 días pero promete 23. Actualizar las estimaciones haría a Olist significativamente más competitivo sin cambios operativos.
2. **Priorizar acuerdos de SLA con vendedores en estados con mayor retraso** — Las rutas con mayor retraso promedio deben tener niveles de servicio renegociados.
3. **Aumentar safety stock en categorías Clase A con OTIF menor al 85%** — Estas representan revenue crítico en riesgo por fallas operativas.

---

---

## 🛠️ Stack Técnico

- **PostgreSQL 18** — Base de datos, diseño de schema, queries analíticas
- **SQL** — Window Functions, CTEs, agregaciones, JOINs múltiples
- **Power BI** — Dashboard, medidas DAX

---

## 📐 Conceptos SQL Utilizados

- **CTEs** para transformaciones en múltiples pasos
- **Window Functions** — `SUM() OVER()`, revenue acumulado para clasificación ABC
- **EXTRACT()** para aritmética de fechas y cálculo de lead time
- **COALESCE()** para manejo de nulos
- **CASE WHEN** para clasificación ABC y scoring de riesgo
- **JOINs múltiples** entre 5+ tablas

---

## 📬 Contacto

**Diego Sánchez Reyes**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-diegoreyes982-blue)](https://www.linkedin.com/in/diegoreyes982/)  
📧 diegoreyes9821@gmail.com
