DROP DATABASE IF EXISTS ss09_tsu202;
CREATE DATABASE ss09_tsu202;
USE ss09_tsu202;

CREATE TABLE IF NOT EXISTS categories (
cat_id INT PRIMARY KEY,
cat_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(255) NOT NULL,
product_price DECIMAL(15, 2) NOT NULL CHECK(product_price >= 0),
cat_id INT,
FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
);

INSERT INTO categories
VALUES(1, 'Quần áo'),
(2, 'Mỹ phẩm'),
(3, 'Gia dụng'),
(4, 'Nội thất'),
(5, 'Thực phẩm');
-- Câu 1 
INSERT INTO products
VALUES(1, 'Áo sơ mi',2000,1),
(2, 'Áo thun',5000,1),
(3, 'Son môi',8000,2);

UPDATE products
SET product_price = 7000
WHERE product_id = 1;
-- Câu 3
-- Tắt chế độ safe update mode
SET SQL_SAFE_UPDATES = 0;
DELETE FROM products
WHERE product_name = 'Son môi';
-- Câu 4
SELECT product_name, product_price
FROM products
ORDER BY product_price ASC; 
-- Câu 5
SELECT cat_name, COUNT(p.product_id) as 'Số lượng'
FROM categories as c
LEFT JOIN products as p
ON c.cat_id = p.cat_id
GROUP BY c.cat_name
-- Sắp xếp tăng dần theo số lượng danh mục 
ORDER BY `Số lượng` ASC;

-- Tạo view
CREATE VIEW view_get_products AS
SELECT *
FROM products;

SELECT * FROM view_get_products;
SELECT * FROM view_get_categories;

CREATE OR REPLACE VIEW view_products AS
SELECT * FROM products
WHERE products_price >5000
WITH CHECK OPTION;

EXPLAIN ANALYZE
SELECT *
FROM products;

CREATE INDEX idx_products
ON products(product_id);



