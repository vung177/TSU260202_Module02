-- 1. Tao cac bang
DROP VIEW IF EXISTS view_customer_spending;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(15, 2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount DECIMAL(15, 2) NOT NULL CHECK (total_amount > 0),
    status ENUM('Pending', 'Success', 'Cancel') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Them du lieu khach hang mau (8 khach hang nhu bai truoc)
INSERT INTO customers (customer_name, email, phone, address) VALUES
('Alice', 'alice@example.com', '1234567890', 'Ha Noi'),
('Bob', 'bob@example.com', '1234567891', 'HCM'),
('Carol', 'carol@example.com', '1234567892', 'Da Nang'),
('David', 'david@example.com', '1234567893', 'Ha Noi'),
('Eva', 'eva@example.com', '1234567894', 'HCM'),
('Frank', 'frank@example.com', '1234567895', 'Da Nang'),
('Grace', 'grace@example.com', '1234567896', 'Ha Noi'),
('Hannah', 'hannah@example.com', '1234567897', 'HCM');

-- Them 8 san pham mau de dat don
INSERT INTO products (product_name, price, stock) VALUES
('Product 1', 2000000.00, 10),
('Product 2', 1500000.00, 20),
('Product 3', 2000000.00, 30),
('Product 4', 1400000.00, 15),
('Product 5', 1200000.00, 25),
('Product 6', 800000.00, 40),
('Product 7', 500000.00, 50),
('Product 8', 4000000.00, 5);

-- Them 20 don hang (12 don thanh cong, 8 don dang cho hoac bi huy)
INSERT INTO orders (customer_id, product_id, quantity, total_amount, status) VALUES
(1, 1, 1, 2000000.00, 'Success'),  -- Alice
(1, 2, 1, 1500000.00, 'Success'),  -- Alice (Total 3.5M, 2 orders)
(2, 3, 1, 2000000.00, 'Success'),  -- Bob
(2, 3, 1, 2000000.00, 'Success'),  -- Bob (Total 4M, 2 orders)
(3, 1, 1, 2000000.00, 'Success'),  -- Carol
(3, 4, 1, 1400000.00, 'Success'),  -- Carol (Total 3.4M, 2 orders)
(4, 5, 1, 1200000.00, 'Success'),  -- David (Total 1.2M, 1 order)
(5, 2, 1, 1500000.00, 'Success'),  -- Eva
(5, 2, 1, 1500000.00, 'Success'),  -- Eva (Total 3M, 2 orders)
(6, 6, 1, 800000.00, 'Success'),   -- Frank (Total 800k, 1 order)
(7, 7, 1, 500000.00, 'Success'),   -- Grace (Total 500k, 1 order)
(8, 8, 1, 4000000.00, 'Success'),  -- Hannah (Total 4M, 1 order)
-- 8 don hang khong thanh cong de lam du 20 ban ghi
(1, 1, 1, 2000000.00, 'Cancel'),
(2, 2, 1, 1500000.00, 'Pending'),
(3, 3, 2, 4000000.00, 'Cancel'),
(4, 4, 1, 1400000.00, 'Pending'),
(5, 5, 1, 1200000.00, 'Cancel'),
(6, 6, 1, 800000.00, 'Pending'),
(7, 7, 1, 500000.00, 'Cancel'),
(8, 8, 1, 4000000.00, 'Cancel');

-- 2. Tao VIEW view_customer_spending
CREATE VIEW view_customer_spending AS
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Success'
GROUP BY c.customer_id, c.customer_name;

-- 3. Truy van de kiem tra ket qua
SELECT * FROM view_customer_spending;
