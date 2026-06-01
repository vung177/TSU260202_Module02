-- 1. Tao cac bang theo thiet ke
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
-- Them danh muc mau
INSERT INTO categories (name)
VALUES ('Electronics'),
    ('Fashion'),
    ('Home & Kitchen');
-- 2. Thuc hien cac yeu cau
-- a. Them 3 san pham moi vao bang products
INSERT INTO products (name, price, category_id)
VALUES ('Laptop Dell', 15000000.00, 1),
    ('T-Shirt', 250000.00, 2),
    ('Blender', 1200000.00, 3);
-- b. Cap nhat gia cua mot san pham da co (vi du cap nhat Laptop Dell co id = 1)
SET SQL_SAFE_UPDATES = 0;
UPDATE products
SET price = 14500000.00
WHERE id = 1;
-- c. Xoa mot san pham (vi du xoa T-Shirt co id = 2)
DELETE FROM products
WHERE id = 2;
SET SQL_SAFE_UPDATES = 1;
-- d. Hien thi tat ca san pham, sap xep theo gia tang dan
SELECT *
FROM products
ORDER BY price ASC;
-- e. Thong ke so luong san pham cho tung danh muc (ke ca danh muc chua co san pham)
SELECT c.name AS category_name,
    COUNT(p.id) AS product_count
FROM categories c
    LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id,
    c.name;