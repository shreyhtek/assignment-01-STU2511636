CREATE TABLE dim_date (
    date_id      INT          PRIMARY KEY,
    full_date    DATE         NOT NULL,
    day          INT          NOT NULL,
    month        INT          NOT NULL,
    month_name   VARCHAR(20)  NOT NULL,
    quarter      INT          NOT NULL,
    year         INT          NOT NULL,
    day_of_week  VARCHAR(15)  NOT NULL,
    is_weekend   BOOLEAN      NOT NULL
);

CREATE TABLE dim_store (
    store_id    INT           PRIMARY KEY,
    store_name  VARCHAR(100)  NOT NULL,
    city        VARCHAR(100)  NOT NULL,
    region      VARCHAR(50)   NOT NULL
);

CREATE TABLE dim_product (
    product_id    INT            PRIMARY KEY,
    product_name  VARCHAR(150)   NOT NULL,
    category      VARCHAR(50)    NOT NULL,
    unit_price    DECIMAL(10,2)  NOT NULL
);

CREATE TABLE dim_customer (
    customer_id    INT          PRIMARY KEY,
    customer_code  VARCHAR(20)  UNIQUE NOT NULL,
    segment        VARCHAR(50)  NOT NULL,
    city           VARCHAR(100) NOT NULL
);

CREATE TABLE fact_sales (
    sales_id        INT            PRIMARY KEY,
    date_id         INT            NOT NULL REFERENCES dim_date(date_id),
    store_id        INT            NOT NULL REFERENCES dim_store(store_id),
    product_id      INT            NOT NULL REFERENCES dim_product(product_id),
    customer_id     INT            NOT NULL REFERENCES dim_customer(customer_id),
    units_sold      INT            NOT NULL CHECK (units_sold > 0),
    unit_price      DECIMAL(10,2)  NOT NULL,
    discount_amount DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    gross_revenue   DECIMAL(12,2)  NOT NULL,
    net_revenue     DECIMAL(12,2)  NOT NULL,
    cost_price      DECIMAL(10,2)  NOT NULL,
    profit          DECIMAL(12,2)  NOT NULL
);


-- ============================================================
--  SEED DATA — dim_store
-- ============================================================

INSERT INTO dim_store (store_id, store_name, city, region) VALUES
  (1, 'Chennai Anna',   'Chennai',   'South'),
  (2, 'Delhi South',    'Delhi',     'North'),
  (3, 'Bangalore MG',   'Bangalore', 'South'),
  (4, 'Pune FC Road',   'Pune',      'West'),
  (5, 'Mumbai Central', 'Mumbai',    'West');


-- ============================================================
--  SEED DATA — dim_product (16 products from raw data)
-- ============================================================

INSERT INTO dim_product (product_id, product_name, category, unit_price) VALUES
  (1,  'Atta 10kg',    'Groceries',    52464.00),
  (2,  'Biscuits',     'Groceries',    27469.99),
  (3,  'Headphones',   'Electronics',  39854.96),
  (4,  'Jacket',       'Clothing',     30187.24),
  (5,  'Jeans',        'Clothing',      2317.47),
  (6,  'Laptop',       'Electronics',  42343.15),
  (7,  'Milk 1L',      'Groceries',    43374.39),
  (8,  'Oil 1L',       'Groceries',    26474.34),
  (9,  'Phone',        'Electronics',  48703.39),
  (10, 'Pulses 1kg',   'Groceries',    31604.47),
  (11, 'Rice 5kg',     'Groceries',    52195.05),
  (12, 'Saree',        'Clothing',     35451.81),
  (13, 'Smartwatch',   'Electronics',  58851.01),
  (14, 'Speaker',      'Electronics',  49262.78),
  (15, 'T-Shirt',      'Clothing',     29770.19),
  (16, 'Tablet',       'Electronics',  23226.12);


-- ============================================================
--  SEED DATA — dim_customer (all 50 customers from raw data)
-- ============================================================

INSERT INTO dim_customer (customer_id, customer_code, segment, city) VALUES
  (1, 'CUST001', 'Retail', 'Mumbai'),
  (2, 'CUST002', 'Retail', 'Bangalore'),
  (3, 'CUST003', 'Retail', 'Delhi'),
  (4, 'CUST004', 'Wholesale', 'Mumbai'),
  (5, 'CUST005', 'Retail', 'Pune'),
  (6, 'CUST006', 'Online', 'Pune'),
  (7, 'CUST007', 'Retail', 'Mumbai'),
  (8, 'CUST008', 'Retail', 'Mumbai'),
  (9, 'CUST009', 'Wholesale', 'Delhi'),
  (10, 'CUST010', 'Retail', 'Pune'),
  (11, 'CUST011', 'Retail', 'Pune'),
  (12, 'CUST012', 'Online', 'Pune'),
  (13, 'CUST013', 'Online', 'Delhi'),
  (14, 'CUST014', 'Online', 'Pune'),
  (15, 'CUST015', 'Retail', 'Mumbai'),
  (16, 'CUST016', 'Online', 'Chennai'),
  (17, 'CUST017', 'Retail', 'Bangalore'),
  (18, 'CUST018', 'Online', 'Delhi'),
  (19, 'CUST019', 'Retail', 'Mumbai'),
  (20, 'CUST020', 'Retail', 'Chennai'),
  (21, 'CUST021', 'Online', 'Bangalore'),
  (22, 'CUST022', 'Online', 'Pune'),
  (23, 'CUST023', 'Wholesale', 'Mumbai'),
  (24, 'CUST024', 'Wholesale', 'Chennai'),
  (25, 'CUST025', 'Online', 'Mumbai'),
  (26, 'CUST026', 'Wholesale', 'Mumbai'),
  (27, 'CUST027', 'Wholesale', 'Bangalore'),
  (28, 'CUST028', 'Online', 'Pune'),
  (29, 'CUST029', 'Retail', 'Pune'),
  (30, 'CUST030', 'Retail', 'Mumbai'),
  (31, 'CUST031', 'Online', 'Delhi'),
  (32, 'CUST032', 'Retail', 'Mumbai'),
  (33, 'CUST033', 'Online', 'Mumbai'),
  (34, 'CUST034', 'Online', 'Bangalore'),
  (35, 'CUST035', 'Retail', 'Bangalore'),
  (36, 'CUST036', 'Online', 'Bangalore'),
  (37, 'CUST037', 'Wholesale', 'Delhi'),
  (38, 'CUST038', 'Wholesale', 'Bangalore'),
  (39, 'CUST039', 'Wholesale', 'Mumbai'),
  (40, 'CUST040', 'Wholesale', 'Delhi'),
  (41, 'CUST041', 'Retail', 'Delhi'),
  (42, 'CUST042', 'Online', 'Chennai'),
  (43, 'CUST043', 'Wholesale', 'Bangalore'),
  (44, 'CUST044', 'Retail', 'Pune'),
  (45, 'CUST045', 'Retail', 'Bangalore'),
  (46, 'CUST046', 'Retail', 'Delhi'),
  (47, 'CUST047', 'Online', 'Bangalore'),
  (48, 'CUST048', 'Retail', 'Bangalore'),
  (49, 'CUST049', 'Wholesale', 'Delhi'),
  (50, 'CUST050', 'Retail', 'Bangalore');
