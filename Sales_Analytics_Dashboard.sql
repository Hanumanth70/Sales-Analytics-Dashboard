

-- SALES ANALYTICS DATABASE SCHEMA

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS returns CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;


-- TABLE 1: CUSTOMERS

CREATE TABLE customers (
    customer_id VARCHAR(100) PRIMARY KEY,
    region VARCHAR(50) NOT NULL,
    country VARCHAR(100) NOT NULL,
    segment VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add index for faster queries
CREATE INDEX idx_customers_region ON customers(region);
CREATE INDEX idx_customers_country ON customers(country);


-- TABLE 2: PRODUCTS

CREATE TABLE products (
    product_id VARCHAR(100) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    unit_cost DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_name ON products(product_name);


-- TABLE 3: ORDERS

CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_date DATE,
    customer_id VARCHAR(100),
    product_id VARCHAR(100),
    units_sold INTEGER CHECK (units_sold > 0),
    unit_price DECIMAL(10,2) CHECK (unit_price >= 0),
    total_revenue DECIMAL(15,2),
    total_cost DECIMAL(15,2),
    total_profit DECIMAL(15,2),
    sales_channel VARCHAR(50),
    order_priority VARCHAR(10),
    days_to_ship INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Add indexes for performance
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_product ON orders(product_id);
CREATE INDEX idx_orders_channel ON orders(sales_channel);


-- TABLE 4: RETURNS

CREATE TABLE returns (
    return_id VARCHAR(50) PRIMARY KEY,
    order_id BIGINT,
    return_date DATE,
    return_reason VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Add index
CREATE INDEX idx_returns_order ON returns(order_id);


-- VERIFICATION QUERIES

-- Check that all tables were created
SELECT table_name 	
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
ALTER TABLE orders
ADD CONSTRAINT orders_product_id_fkey
FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE CASCADE;

--Query 1: Overall Business Metrics

SELECT 
    COUNT(DISTINCT order_id) as total_orders,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(total_revenue)::NUMERIC(15,2) as total_revenue,
    SUM(total_profit)::NUMERIC(15,2) as total_profit,
    ROUND(AVG(total_profit / NULLIF(total_revenue, 0) * 100), 2) as avg_profit_margin_pct,
    MIN(order_date) as first_order,
    MAX(order_date) as last_order
FROM orders;

--Query 2: Top 5 Regions

SELECT 
    c.region,
    COUNT(o.order_id) as orders,
    SUM(o.total_revenue)::NUMERIC(15,2) as revenue,
    SUM(o.total_profit)::NUMERIC(15,2) as profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY revenue DESC
LIMIT 5;

--Query 3: Top 5 Products

SELECT 
    p.product_name,
    COUNT(o.order_id) as times_sold,
    SUM(o.total_revenue)::NUMERIC(15,2) as revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;


-- VIEWS FOR POWER BI DASHBOARD 

-- View 1: Complete Sales Summary
CREATE OR REPLACE VIEW vw_sales_summary AS
SELECT 
    o.order_id,
    o.order_date,
    EXTRACT(YEAR FROM o.order_date) as order_year,
    EXTRACT(MONTH FROM o.order_date) as order_month,
    TO_CHAR(o.order_date, 'Month') as order_month_name,
    EXTRACT(QUARTER FROM o.order_date) as order_quarter,
    o.ship_date,
    o.days_to_ship,
    c.customer_id,
    c.region,
    c.country,
    c.segment,
    p.product_id,
    p.product_name,
    p.category,
    o.units_sold,
    o.unit_price,
    p.unit_cost,
    o.total_revenue,
    o.total_cost,
    o.total_profit,
    ROUND(o.total_profit / NULLIF(o.total_revenue, 0) * 100, 2) as profit_margin_pct,
    o.sales_channel,
    o.order_priority,
    CASE WHEN r.return_id IS NOT NULL THEN 'Yes' ELSE 'No' END as is_returned,
    r.return_reason
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
LEFT JOIN returns r ON o.order_id = r.order_id;

-- View 2: Product Performance
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(o.units_sold) as units_sold,
    SUM(o.total_revenue)::NUMERIC(15,2) as revenue,
    SUM(o.total_profit)::NUMERIC(15,2) as profit,
    ROUND(SUM(o.total_profit) / NULLIF(SUM(o.total_revenue), 0) * 100, 2) as profit_margin_pct,
    COUNT(DISTINCT r.return_id) as return_count
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY p.product_id, p.product_name, p.category;

-- View 3: Regional Performance
CREATE OR REPLACE VIEW vw_regional_performance AS
SELECT 
    c.region,
    c.country,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(o.total_revenue)::NUMERIC(15,2) as revenue,
    SUM(o.total_profit)::NUMERIC(15,2) as profit,
    ROUND(AVG(o.total_revenue), 2) as avg_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = c.customer_id
GROUP BY c.region, c.country;

-- View 4: Monthly Trends
CREATE OR REPLACE VIEW vw_monthly_trends AS
SELECT 
    DATE_TRUNC('month', order_date) as month,
    TO_CHAR(order_date, 'YYYY-MM') as month_year,
    COUNT(order_id) as orders,
    SUM(total_revenue)::NUMERIC(15,2) as revenue,
    SUM(total_profit)::NUMERIC(15,2) as profit
FROM orders
GROUP BY DATE_TRUNC('month', order_date), TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

-- Verify views created
SELECT table_name as view_name
FROM information_schema.views 
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT * FROM vw_sales_summary;