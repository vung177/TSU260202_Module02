-- 1. Tao bang products
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(15, 2)
);

-- 2. Them du lieu mau
INSERT INTO products (product_name, category, price) VALUES
('Dell XPS 13', 'Laptop', 25000000.00),
('HP Pavilion', 'Laptop', 15000000.00),
('MacBook Air', 'Laptop', 22000000.00),
('iPhone 13', 'Phone', 14000000.00),
('Samsung Galaxy A54', 'Phone', 8000000.00),
('Oppo Reno 10', 'Phone', 10000000.00),
('iPad Pro', 'Tablet', 24000000.00),
('Samsung Tab A9', 'Tablet', 4000000.00);

-- 3. Truy van theo yeu cau
-- a. San pham co gia cao hon gia trung binh cua tat ca san pham
SELECT * FROM products 
WHERE price > (SELECT AVG(price) FROM products);

-- b. San pham co gia cao nhat trong tung loai san pham (dung subquery lien quan)
SELECT * FROM products p
WHERE price = (SELECT MAX(price) FROM products WHERE category = p.category);

-- c. San pham thuoc cac loai (category) co it nhat mot san pham gia tren 20.000.000
SELECT * FROM products 
WHERE category IN (
    SELECT DISTINCT category 
    FROM products 
    WHERE price > 20000000
);
