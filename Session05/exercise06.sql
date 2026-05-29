-- 1. Tao cac bang
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    customer_id INT, -- khai bao theo yeu cau de bai
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (order_id, product_name),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 2. Them du lieu mau
INSERT INTO customers (customer_name) VALUES
('Nguyen Van A'),
('Tran Thi B'),
('Le Van C');

INSERT INTO orders (order_date, customer_id) VALUES
('2026-05-20', 1),
('2026-05-21', 2),
('2026-05-22', 3),
('2026-05-23', 1);

INSERT INTO order_items (order_id, customer_id, product_name, quantity, price) VALUES
(1, 1, 'Laptop Dell', 1, 25000000.00), -- Don 1: 25.000.000
(2, 2, 'iPhone 13', 1, 14000000.00),
(2, 2, 'Phone Case', 2, 2000000.00), -- Don 2: 18.000.000 (Khach 2 tong: 18.000.000)
(3, 3, 'Mouse Logi', 2, 500000.00), -- Don 3: 1.000.000 (Khach 3 tong: 1.000.000)
(4, 1, 'Charger Anker', 1, 300000.00); -- Don 4: 300.000 (Khach 1 tong: 25.300.000)

-- 3. Truy van theo yeu cau
-- a. Ma don hang, ten khach hang, tong tien cua don hang
SELECT o.order_id, c.customer_name, SUM(oi.quantity * oi.price) AS total_order_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name;

-- b. Tong doanh thu cua moi khach hang
SELECT c.customer_id, c.customer_name, SUM(oi.quantity * oi.price) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name;

-- c. Chi hien thi cac khach hang co tong doanh thu lon hon 20.000.000
SELECT c.customer_id, c.customer_name, SUM(oi.quantity * oi.price) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
HAVING total_revenue > 20000000;

-- d. Khach hang co doanh thu cao nhat
SELECT c.customer_id, c.customer_name, SUM(oi.quantity * oi.price) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 1;
