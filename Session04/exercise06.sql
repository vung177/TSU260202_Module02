-- 1. Tao bang products
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(15, 2) NOT NULL,
    quantity INT
);

-- 2. Them du lieu mau
INSERT INTO products (product_name, category, price, quantity) VALUES
('Samsung Galaxy S24', 'Phone', 22000000.00, 10),
('Dell XPS 13', 'Laptop', 25000000.00, 5),
('HP Pavilion', 'Laptop', 12000000.00, 8),
('iPad Pro', 'Tablet', 18000000.00, 0),
('Samsung Tab A9', 'Tablet', 4500000.00, 15),
('iPhone 13', 'Phone', 14000000.00, 12),
('Asus Zenbook', 'Laptop', 15000000.00, 0);

-- 3. Truv van du lieu
-- a. San pham co gia tu 5.000.000 den 15.000.000
SELECT * FROM products WHERE price BETWEEN 5000000 AND 15000000;

-- b. San pham thuoc loai Laptop hoac Tablet
SELECT * FROM products WHERE category IN ('Laptop', 'Tablet');

-- c. San pham co ten bat dau bang "Sam"
SELECT * FROM products WHERE product_name LIKE 'Sam%';

-- d. San pham khong thuoc loai Phone
SELECT * FROM products WHERE category <> 'Phone';

-- 4. Cap nhat va xoa du lieu
SET SQL_SAFE_UPDATES = 0;

-- a. Giam gia 5% cho Laptop
UPDATE products 
SET price = price * 0.95 
WHERE category = 'Laptop';

-- Kiem tra sau khi cap nhat
SELECT * FROM products;

-- b. Xoa san pham co ton kho bang 0
DELETE FROM products 
WHERE quantity = 0;

-- Kiem tra sau khi xoa
SELECT * FROM products;

SET SQL_SAFE_UPDATES = 1;
