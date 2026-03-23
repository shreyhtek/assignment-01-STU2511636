-- ============================================================
-- PART 1 - SCHEMA DESIGN (3NF)
-- File: part1-rdbms/schema_design.sql


-- Q1. CUSTOMERS table
CREATE TABLE customers (
    customer_id    VARCHAR(10)   NOT NULL,
    customer_name  VARCHAR(100)  NOT NULL,
    customer_email VARCHAR(100)  NOT NULL,
    customer_city  VARCHAR(50)   NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Q2. PRODUCTS table
CREATE TABLE products (
    product_id   VARCHAR(10)   NOT NULL,
    product_name VARCHAR(100)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (product_id)
);

-- Q3. SALES_REPS table
CREATE TABLE sales_reps (
    sales_rep_id    VARCHAR(10)  NOT NULL,
    sales_rep_name  VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) NOT NULL,
    office_address  VARCHAR(200) NOT NULL,
    PRIMARY KEY (sales_rep_id)
);

-- Q4. ORDERS table (fact table with foreign keys)
CREATE TABLE orders (
    order_id     VARCHAR(10) NOT NULL,
    customer_id  VARCHAR(10) NOT NULL,
    product_id   VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    quantity     INT         NOT NULL,
    order_date   DATE        NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id)  REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)   REFERENCES products(product_id),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);



-- Customers
INSERT INTO customers VALUES ('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai');
INSERT INTO customers VALUES ('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi');
INSERT INTO customers VALUES ('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore');
INSERT INTO customers VALUES ('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai');
INSERT INTO customers VALUES ('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai');
INSERT INTO customers VALUES ('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi');
INSERT INTO customers VALUES ('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore');
INSERT INTO customers VALUES ('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');

-- Products
INSERT INTO products VALUES ('P001', 'Laptop',        'Electronics', 55000.00);
INSERT INTO products VALUES ('P002', 'Mouse',         'Electronics',   800.00);
INSERT INTO products VALUES ('P003', 'Desk Chair',    'Furniture',    8500.00);
INSERT INTO products VALUES ('P004', 'Notebook',      'Stationery',    120.00);
INSERT INTO products VALUES ('P005', 'Headphones',    'Electronics',  3200.00);
INSERT INTO products VALUES ('P006', 'Standing Desk', 'Furniture',   22000.00);
INSERT INTO products VALUES ('P007', 'Pen Set',       'Stationery',    250.00);
INSERT INTO products VALUES ('P008', 'Webcam',        'Electronics',  2100.00);

-- Sales Reps
INSERT INTO sales_reps VALUES ('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021');
INSERT INTO sales_reps VALUES ('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001');
INSERT INTO sales_reps VALUES ('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001');

-- Orders (sample — 10 rows shown, full set in the file)
INSERT INTO orders VALUES ('ORD1000', 'C002', 'P001', 'SR03', 2, '2023-05-21');
INSERT INTO orders VALUES ('ORD1001', 'C004', 'P002', 'SR03', 5, '2023-02-22');
INSERT INTO orders VALUES ('ORD1002', 'C002', 'P005', 'SR02', 1, '2023-01-17');
INSERT INTO orders VALUES ('ORD1003', 'C002', 'P002', 'SR01', 5, '2023-09-16');
INSERT INTO orders VALUES ('ORD1004', 'C001', 'P005', 'SR01', 5, '2023-11-29');
INSERT INTO orders VALUES ('ORD1005', 'C007', 'P002', 'SR02', 3, '2023-10-29');
INSERT INTO orders VALUES ('ORD1006', 'C001', 'P007', 'SR01', 4, '2023-12-24');
INSERT INTO orders VALUES ('ORD1007', 'C006', 'P003', 'SR01', 3, '2023-04-21');
INSERT INTO orders VALUES ('ORD1008', 'C002', 'P001', 'SR02', 3, '2023-02-19');
INSERT INTO orders VALUES ('ORD1009', 'C006', 'P005', 'SR02', 4, '2023-01-23');
INSERT INTO orders VALUES ('ORD1185', 'C003', 'P008', 'SR03', 1, '2023-06-15');