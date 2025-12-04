## 🎯 Project Overview:

Comprehensive data analysis project analyzing **10,000 sales transactions** representing **13,333.55 million in revenue** across multiple regions, products, and customer segments. Built an end-to-end analytics solution from raw data to interactive visualizations.

---

## 🛠️ Tools & Technologies

- **Microsoft Excel** - Data cleaning, transformation, and exploratory analysis
- **PostgreSQL** - Database design, SQL queries, and data modeling
- **Power BI** - Interactive dashboards and business intelligence visualizations
- **pgAdmin** - Database management
- **Git/GitHub** - Version control and project documentation

---

## 📂 Project Structure
```
Sales_Analytics_Project/
├── 01_Raw_Data/           # Original CSV datasets (10K+ rows)
├── 02_Excel_Work/         # Cleaned and transformed data
├── 03_SQL_Scripts/        # PostgreSQL queries and database schema
├── 04_PowerBI/            # Interactive dashboard (.pbix file)
└── README.md              # Project documentation
```

---

## 🔄 Project Workflow

### Phase 1: Data Collection & Preparation (Excel)
- Downloaded and explored raw sales data (10,000 transactions)
- Performed data quality assessment (duplicates, missing values, data types)
- Created calculated columns (Profit Margin %, Order Quarter, Revenue Categories)
- Normalized data into 4 structured tables (Customers, Products, Orders, Returns)
- Exported cleaned data as CSV files for database import

### Phase 2: Database Design & SQL Analysis (PostgreSQL)
- Designed normalized database schema with proper relationships
- Created 4 tables with primary/foreign key constraints
- Imported 10,000+ rows using COPY commands
- Wrote 10+ complex SQL queries including:
  - Aggregate functions (SUM, AVG, COUNT)
  - JOINs across multiple tables
  - Common Table Expressions (CTEs)
  - Window functions for trend analysis
  - Subqueries for advanced filtering
- Created 4 optimized views for Power BI integration

### Phase 3: Interactive Dashboard (Power BI)
- Connected Power BI to PostgreSQL database
- Built comprehensive data model with relationships
- Created 7 DAX measures for key metrics
- Designed 2 dashboard pages with 15+ visualizations
- Implemented interactive filters and drill-through capabilities
- Applied professional formatting and branding

---

## 🎯 Key Results

### Business Metrics
- **Revenue:** 13.33M | **Profit:** 3.95M | **Margin:** 29.6%
- **Orders:** 10,000 | **Avg Order Value:** $1.33M

### Top Insights
- **Europe** leads with 3.48M revenue (26% share, 29.5% margin)
- **Balanced channels:** 50.07% Online, 49.93% Offline
- **Top products:** Household, Office Supplies, Cosmetics
- **Trend alert:** Revenue decline in 2017 requires investigation

---

## 📊 Dashboard Features

### Page 1: Executive Summary
- 4 KPI cards (Revenue, Profit, Orders, Margin)
- Sales trend line chart (2010-2017)
- Geographic distribution map
- Top 10 products bar chart
- Channel split donut chart
- Regional performance table
- Interactive filters (Year, Region)

### Page 2: Customer Analysis
- Customer KPIs (Total, Avg Revenue, Avg Orders)
- Distribution by segment & region
- Growth trend analysis
- Top 20 customers table
- Interactive segment filters

---

## 💡 Technical Highlights

### Data Preparation (Excel)
- Cleaned 10K+ rows, removed duplicates
- Created calculated fields (Profit Margin %, Categories)
- Normalized into 4 tables (Customers, Products, Orders, Returns)

### Database & SQL (PostgreSQL)
- Designed normalized schema with relationships
- Wrote 15+ queries (JOINs, CTEs, window functions)
- Created optimized views for Power BI
- Implemented indexes for performance

### Visualization (Power BI)
- Built 2-page interactive dashboard
- Created 7 DAX measures
- 15+ visualizations with cross-filtering
- Dynamic slicers and drill-through

---

## 🚀 Skills Demonstrated
✅ Data Cleaning & Transformation  
✅ Database Design & Normalization  
✅ Advanced SQL (JOINs, CTEs, Window Functions)  
✅ Data Modeling & Relationships  
✅ DAX Measures & Calculations  
✅ Interactive Dashboard Design  
✅ Business Intelligence & Insights  
✅ Data Storytelling  

---

## 📸 Images

### Executive Dashboard:

![Dashboard Page 1](https://github.com/Hanumanth70/Sales-Analytics-Dashboard/blob/main/Sales%20Analytics_Dashboard_page1.jpg)

### Customer Analysis:

![Dashboard Page 2](https://github.com/Hanumanth70/Sales-Analytics-Dashboard/blob/main/Sales%20Analytics_Dashboard_page2.jpg)


---

## 🔍 Sample SQL Query
```sql
-- Regional Performance Analysis
SELECT 
    c.region,
    COUNT(DISTINCT o.order_id) as orders,
    SUM(o.total_revenue)::NUMERIC(15,2) as revenue,
    SUM(o.total_profit)::NUMERIC(15,2) as profit,
    ROUND(SUM(o.total_profit) / NULLIF(SUM(o.total_revenue), 0) * 100, 2) as margin_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY revenue DESC;
```

---

## 📦 Setup Instructions

1. **Clone repository**
```bash
   git clone https://github.com/Hanumanth70/Sales-Analytics-Dashboard
```

2. **Setup PostgreSQL**
```sql
   CREATE DATABASE sales_analytics;
   \i 03_SQL_Scripts/create_tables.sql
   \i 03_SQL_Scripts/import_data.sql
```

3. **Open Power BI**
   - Open `Sales Analytics_Dashboard.pbix`
   - Connect to localhost PostgreSQL
   - Refresh data

---

## 📞 Connect

**GitHub:** [github.com/yourusername](https://github.com/Hanumanth70)  
**LinkedIn:** [linkedin.com/in/yourname](https://www.linkedin.com/in/hanumanthmhugar)
**Email:** hanumanthmhugar70@gmail.com

---

⭐ **Star this repo if you find it helpful!**

*Last Updated: December 2025*

---



