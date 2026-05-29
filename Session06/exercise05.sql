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

-- Them du lieu mau
INSERT INTO categories (name) VALUES 
('Electronics'), 
('Fashion'), 
('Books');

INSERT INTO products (name, price, category_id) VALUES
('Laptop Dell', 20000000.00, 1),
('iPhone 13', 15000000.00, 1),
('Keyboard', 1000000.00, 1),
('Mouse', 500000.00, 1),
('T-Shirt', 400000.00, 2),
('Shoes', 1500000.00, 2),
('SQL Book', 300000.00, 3), -- chua tung ban
('USB Cable', 100000.00, 1); -- chua tung ban

INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com'),
('Eva', 'eva@example.com'),
('Frank', 'frank@example.com'),
('Grace', 'grace@example.com'); -- chua tung dat don

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2026-05-20'),
(2, '2026-05-21'),
(3, '2026-05-22'),
(4, '2026-05-23'),
(5, '2026-05-24'),
(6, '2026-05-25');

INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 20000000.00), -- Alice chi tieu: 20.000.000
(2, 2, 1, 15000000.00), -- Bob chi tieu: 15.000.000
(3, 6, 2, 1500000.00),  -- Charlie chi tieu: 3.000.000
(4, 3, 5, 1000000.00),  -- David chi tieu: 5.000.000
(5, 5, 10, 400000.00),  -- Eva chi tieu: 4.000.000
(6, 4, 4, 500000.00);   -- Frank chi tieu: 2.000.000

-- =========================================
-- THUC HIEN CAC YEU CAU
-- =========================================

-- a. Liet ke san pham cung voi ten danh muc tuong ung
SELECT p.id AS product_id, p.name AS product_name, p.price, c.name AS category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.id;

-- b. Dem so don hang cua tung khach hang
SELECT c.id AS customer_id, c.name AS customer_name, COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- c. Xac dinh 5 khach hang co tong doanh thu chi tieu cao nhat
SELECT c.id AS customer_id, c.name AS customer_name, SUM(od.quantity * od.price) AS total_spent
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
INNER JOIN order_details od ON o.id = od.order_id
GROUP BY c.id, c.name
ORDER BY total_spent DESC
LIMIT 5;

-- d. Tim cac san pham chua tung xuat hien trong bat ky don hang nao
SELECT p.id AS product_id, p.name AS product_name, p.price
FROM products p
LEFT JOIN order_details od ON p.id = od.product_id
WHERE od.product_id IS NULL;

-- e. Tim nhung khach hang da mua san pham thuoc danh muc co so luong san pham lon nhat
SELECT DISTINCT c.id AS customer_id, c.name AS customer_name, c.email
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
INNER JOIN order_details od ON o.id = od.order_id
INNER JOIN products p ON od.product_id = p.id
WHERE p.category_id = (
    -- Lay ra category_id co nhieu san pham nhat trong bang products
    SELECT category_id 
    FROM products 
    GROUP BY category_id 
    ORDER BY COUNT(id) DESC 
    LIMIT 1
);
