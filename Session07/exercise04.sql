-- 1. Tao bang products
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(15, 2) NOT NULL
);

-- 2. Tao INDEX ket hop (Composite Index) cho hai cot category va price
-- Thu tu cot: category dung truoc de loc truoc, price dung sau de loc tiep theo
CREATE INDEX idx_category_price ON products(category, price);
