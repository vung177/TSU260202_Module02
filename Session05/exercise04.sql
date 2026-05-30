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
    customer_id INT,
    -- khai bao theo dung cot trong yeu cau de bai
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (order_id, product_name),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
-- 2. Them du lieu mau
INSERT INTO customers (customer_name)
VALUES ('Nguyen Van A'),
    ('Tran Thi B');
INSERT INTO orders (order_date, customer_id)
VALUES ('2026-05-20', 1),
    ('2026-05-21', 2),
    ('2026-05-22', 1),
    ('2026-05-23', 2);
INSERT INTO order_items (
        order_id,
        customer_id,
        product_name,
        quantity,
        price
    )
VALUES (1, 1, 'Laptop Dell', 1, 15000000.00),
    (2, 2, 'iPhone 13', 1, 14000000.00),
    (2, 2, 'Phone Case', 2, 2000000.00),
    -- Tong don 2 = 18.000.000
    (3, 1, 'Mouse Logi', 2, 500000.00),
    (4, 2, 'Charger Anker', 1, 300000.00);
-- 3. Truy van theo yeu cau
-- a. Hien thi: ma don hang, ngay dat hang, ten khach hang
SELECT o.order_id,
    o.order_date,
    c.customer_name
FROM orders AS o
    INNER JOIN customers AS c ON o.customer_id = c.customer_id;
-- b. Hien thi: danh sach san pham trong moi don hang
SELECT o.order_id,
    oi.product_name,
    oi.quantity,
    oi.price
FROM orders AS o
    INNER JOIN order_items AS oi ON o.order_id = oi.order_id;
-- c. Tinh: tong tien cua moi don hang
SELECT order_id,
    SUM(quantity * price) AS total_amount
FROM order_items
GROUP BY order_id;
-- d. Hien thi: cac don hang co tong tien lon hon 10.000.000
SELECT order_id,
    SUM(quantity * price) AS total_amount
FROM order_items
GROUP BY order_id
HAVING total_amount > 10000000;