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

-- 2. Them du lieu mau
INSERT INTO categories (name) VALUES 
('Electronics'), 
('Fashion'), 
('Home');

INSERT INTO products (name, price, category_id) VALUES
('Laptop Dell', 25000000.00, 1),
('iPhone 13', 15000000.00, 1),
('Samsung Galaxy S23', 18000000.00, 1),
('T-Shirt', 500000.00, 2),
('Jeans', 800000.00, 2),
('Shoes', 2000000.00, 2),
('Blender', 1200000.00, 3),
('Toaster', 800000.00, 3);

-- =========================================
-- THUC HIEN CAC YEU CAU
-- =========================================

-- a. Tim cac san pham co gia nam trong mot khoang cu the (vi du tu 1.000.000 den 20.000.000)
SELECT * FROM products 
WHERE price BETWEEN 1000000 AND 20000000;

-- b. Tim cac san pham co ten chua mot chuoi ky tu nhat dinh (vi du chua chu 'Samsung')
SELECT * FROM products 
WHERE name LIKE '%Samsung%';

-- c. Tinh gia trung binh cua san pham cho moi danh muc
SELECT c.name AS category_name, AVG(p.price) AS average_price
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name;

-- d. Tim nhung san pham co gia cao hon muc gia trung binh cua toan bo san pham
SELECT * FROM products 
WHERE price > (SELECT AVG(price) FROM products);

-- e. Tim san pham co gia thap nhat cho tung danh muc (su dung subquery lien quan)
SELECT p.id, p.name AS product_name, p.price, c.name AS category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.id
WHERE p.price = (SELECT MIN(price) FROM products WHERE category_id = p.category_id);
