-- Create database
CREATE DATABASE flipkart_database;


--Create customers table--
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    state VARCHAR(100)
);

--Create products table--
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2),
    cogs NUMERIC(10,2),
    category VARCHAR(100),
    brand VARCHAR(100)
);

--Create sales table (orders)--
CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT REFERENCES customers(customer_id),
    order_status VARCHAR(100),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price_per_unit NUMERIC(10,2)
);


--Create payment table--
CREATE TABLE payment (
    payment_id INT PRIMARY KEY,
    order_id INT REFERENCES sales(order_id),
    payment_date DATE,
    payment_status VARCHAR(100)
);

--Create shippings table--
CREATE TABLE shippings (
    shipping_id INT PRIMARY KEY,
    order_id INT REFERENCES sales(order_id),
    shipping_date DATE,
    shipping_providers VARCHAR(100),
    delivery_status VARCHAR(100),
    return_date DATE
);
