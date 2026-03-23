CREATE TABLE customers (
    customer_id   VARCHAR(10)  PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) UNIQUE,
    customer_city  VARCHAR(100)
);

CREATE TABLE products (
    product_id   VARCHAR(10)  PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50),
    unit_price   DECIMAL(10,2) NOT NULL
);

CREATE TABLE sales_reps (
    sales_rep_id   VARCHAR(10)  PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(150) UNIQUE,
    office_address  VARCHAR(255)
);

CREATE TABLE orders (
    order_id     VARCHAR(20)  PRIMARY KEY,
    customer_id  VARCHAR(10)  NOT NULL REFERENCES customers(customer_id),
    product_id   VARCHAR(10)  NOT NULL REFERENCES products(product_id),
    sales_rep_id VARCHAR(10)  REFERENCES sales_reps(sales_rep_id),
    quantity     INT          NOT NULL CHECK (quantity > 0),
    order_date   DATE         NOT NULL
    -- unit_price is intentionally left in products table;
    -- if you need historical price snapshots, add a
    -- unit_price_at_order DECIMAL(10,2) column here.
);


-- ============================================================
--  SEED DATA  (clean, de-duplicated from the flat CSV)
-- ============================================================

INSERT INTO customers VALUES
  ('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai'),
  ('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi'),
  ('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore'),
  ('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai'),
  ('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
  ('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi'),
  ('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore'),
  ('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');

INSERT INTO products VALUES
  ('P001', 'Laptop',        'Electronics',  55000.00),
  ('P002', 'Mouse',         'Electronics',    800.00),
  ('P003', 'Desk Chair',    'Furniture',     8500.00),
  ('P004', 'Notebook',      'Stationery',     120.00),
  ('P005', 'Headphones',    'Electronics',   3200.00),
  ('P006', 'Standing Desk', 'Furniture',    22000.00),
  ('P007', 'Pen Set',       'Stationery',     250.00),
  ('P008', 'Webcam',        'Electronics',   2100.00),
  -- Extra product added without any order (fixes INSERT anomaly)
  ('P009', 'Whiteboard',    'Stationery',    1500.00);

-- SR01 office address corrected to the canonical spelling
INSERT INTO sales_reps VALUES
  ('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
  ('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001'),
  ('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001');


-- ============================================================
--  QUERIES
-- ============================================================

-- Q1: List all customers from Mumbai along with their total order value
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_city,
    SUM(o.quantity * p.unit_price) AS total_order_value
FROM customers c
JOIN orders    o ON o.customer_id = c.customer_id
JOIN products  p ON p.product_id  = o.product_id
WHERE c.customer_city = 'Mumbai'
GROUP BY c.customer_id, c.customer_name, c.customer_city
ORDER BY total_order_value DESC;


-- Q2: Find the top 3 products by total quantity sold
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS total_quantity_sold
FROM products p
JOIN orders   o ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 3;


-- Q3: List all sales representatives and the number of unique customers they have handled
SELECT
    sr.sales_rep_id,
    sr.sales_rep_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM sales_reps sr
LEFT JOIN orders o ON o.sales_rep_id = sr.sales_rep_id
GROUP BY sr.sales_rep_id, sr.sales_rep_name
ORDER BY unique_customers DESC;


-- Q4: Find all orders where the total value exceeds 10,000, sorted by value descending
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    o.quantity,
    p.unit_price,
    (o.quantity * p.unit_price) AS order_value,
    o.order_date
FROM orders   o
JOIN customers c ON c.customer_id = o.customer_id
JOIN products  p ON p.product_id  = o.product_id
WHERE (o.quantity * p.unit_price) > 10000
ORDER BY order_value DESC;


-- Q5: Identify any products that have never been ordered
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM products p
LEFT JOIN orders o ON o.product_id = p.product_id
WHERE o.order_id IS NULL;