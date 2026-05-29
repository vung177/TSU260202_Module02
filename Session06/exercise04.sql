-- 1. Tao cac bang
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_details (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DOUBLE NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Them du lieu mau ban dau
INSERT INTO categories (name) VALUES ('Electronics'), ('Fashion');

INSERT INTO products (name, price, category_id) VALUES
('Laptop Dell', 25000000.00, 1),
('iPhone 13', 15000000.00, 1),
('T-Shirt', 500000.00, 2),
('Shoes', 2000000.00, 2),
('Keyboard', 1000000.00, 1),
('Mouse', 500000.00, 1);

INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2026-05-20'),
(2, '2026-05-21'),
(3, '2026-05-22');

INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 25000000.00), -- Laptop Dell (1)
(1, 6, 2, 500000.00),    -- Mouse (2)
(2, 2, 1, 15000000.00), -- iPhone 13 (1)
(2, 5, 1, 1000000.00),   -- Keyboard (1)
(3, 3, 5, 500000.00),    -- T-Shirt (5)
(3, 4, 1, 2000000.00);   -- Shoes (1)

-- =========================================
-- THUC HIEN CAC YEU CAU
-- =========================================

-- a. Them mot don hang moi vao orders va chi tiet vao order_details
-- Them don hang moi (id = 4) cho Bob (customer_id = 2)
INSERT INTO orders (customer_id, order_date) VALUES (2, '2026-05-24');
-- Them chi tiet cho don hang moi vua tao
INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(4, 5, 2, 1000000.00), -- Keyboard (2)
(4, 6, 3, 500000.00);  -- Mouse (3)

-- b. Tinh tong doanh thu cua toan bo cua hang
SELECT SUM(quantity * price) AS total_store_revenue 
FROM order_details;

-- c. Tinh doanh thu trung binh cua moi don hang
SELECT AVG(order_total) AS average_order_revenue
FROM (
    SELECT order_id, SUM(quantity * price) AS order_total
    FROM order_details
    GROUP BY order_id
) order_totals;

-- d. Tim va hien thi thong tin cua don hang co doanh thu cao nhhat
SELECT o.id AS order_id, o.order_date, c.name AS customer_name, SUM(od.quantity * od.price) AS total_revenue
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN order_details od ON o.id = od.order_id
GROUP BY o.id, o.order_date, c.name
ORDER BY total_revenue DESC
LIMIT 1;

-- e. Tim va hien thi danh sach 3 san pham ban chay nhat dua tren tong so luong da ban
SELECT p.id AS product_id, p.name AS product_name, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
INNER JOIN products p ON od.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 3;
