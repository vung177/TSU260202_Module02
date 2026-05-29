-- 1. Tao cac bang va du lieu mau
DROP VIEW IF EXISTS v_order_info;
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

INSERT INTO customers (customer_name) VALUES
('Nguyen Van A'),
('Tran Thi B'),
('Le Van C');

INSERT INTO orders (order_date, customer_id) VALUES
('2026-05-20', 1),
('2026-05-21', 2),
('2026-05-22', 1);

-- 2. Tao VIEW v_order_info tu hai bang customers va orders
CREATE VIEW v_order_info AS
SELECT o.order_id, o.order_date, c.customer_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- 3. Truy van kiem tra VIEW
SELECT * FROM v_order_info;
