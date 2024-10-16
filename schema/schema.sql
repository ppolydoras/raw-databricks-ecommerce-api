CREATE DATABASE IF NOT EXISTS ecommerce_demo;
USE ecommerce_demo;

-- Customers table
CREATE TABLE customers (
  customer_id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  phone STRING,
  address STRING,
  city STRING,
  state STRING,
  zip_code STRING,
  registration_date DATE
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/customers.csv',
  header 'true',
  inferSchema 'true'
);

-- Categories
CREATE TABLE categories (
  category_id INT,
  category_name STRING,
  description STRING
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/categories.csv',
  header 'true',
  inferSchema 'true'
);

-- Suppliers
CREATE TABLE suppliers (
  supplier_id INT,
  supplier_name STRING,
  contact_name STRING,
  contact_email STRING,
  phone STRING,
  address STRING
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/suppliers.csv',
  header 'true',
  inferSchema 'true'
);

-- Products
CREATE TABLE products (
  product_id INT,
  product_name STRING,
  category_id INT,
  supplier_id INT,
  price DECIMAL(10,2),
  description STRING
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/products.csv',
  header 'true',
  inferSchema 'true'
);

-- Inventory
CREATE TABLE inventory (
  inventory_id INT,
  product_id INT,
  quantity_in_stock INT,
  last_updated DATE
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/inventory.csv',
  header 'true',
  inferSchema 'true'
);

-- Orders
CREATE TABLE orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  status STRING,
  total_amount DECIMAL(10,2)
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/orders.csv',
  header 'true',
  inferSchema 'true'
);

-- Order_item
CREATE TABLE order_items (
  order_item_id INT,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2)
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/order_items.csv',
  header 'true',
  inferSchema 'true'
);

-- Reviews
CREATE TABLE reviews (
  review_id INT,
  product_id INT,
  customer_id INT,
  rating INT,
  review_text STRING,
  review_date DATE
)
USING CSV
OPTIONS (
  path 's3a://rawlabs-public-test-data/demos/databricks/ecommerce_data/reviews.csv',
  header 'true',
  inferSchema 'true'
);
