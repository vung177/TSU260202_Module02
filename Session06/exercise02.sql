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

-- Them du lieu mau co ban
INSERT INTO categories (name) VALUES ('Electronics'), ('Fashion');

INSERT INTO products (name, price, category_id) VALUES
('Laptop Dell', 25000000.00, 1),
('iPhone 13', 15000000.00, 1),
('T-Shirt', 500000.00, 2),
('Shoes', 2000000.00, 2);

INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2026-05-20'),
(2, '2026-05-21');

INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 25000000.00), -- Alice mua Laptop Dell (gia cao nhat)
(1, 3, 2, 500000.00),
(2, 2, 1, 15000000.00); -- Bob mua iPhone 13

-- =========================================
-- THUC HIEN CAC YEU CAU
-- =========================================

-- a. Them 2 khach hang moi vao bang customers
INSERT INTO customers (name, email) VALUES
('Eva', 'eva@example.com'),
('Frank', 'frank@example.com');

-- b. Liet ke nhung khach hang da co it nhat mot don hang
SELECT DISTINCT c.id, c.name, c.email 
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id;

-- c. Tim nhung khach hang chua tung dat don hang nao
SELECT c.id, c.name, c.email 
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- d. Tinh toan tong doanh thu ma moi khach hang da mang lai
SELECT c.id, c.name, COALESCE(SUM(od.quantity * od.price), 0) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
LEFT JOIN order_details od ON o.id = od.order_id
GROUP BY c.id, c.name;

-- e. Xac dinh khach hang da mua san pham co gia cao nhat
SELECT DISTINCT c.id, c.name, p.name AS product_name, p.price AS product_price
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
INNER JOIN order_details od ON o.id = od.order_id
INNER JOIN products p ON od.product_id = p.id
WHERE p.price = (SELECT MAX(price) FROM products);
