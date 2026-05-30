-- 1. Tao bang products
DROP PROCEDURE IF EXISTS get_high_value_products;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(15, 2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

-- 2. Them 20 ban ghi vao bang products (cac san pham trung khop voi anh chup man hinh ket qua)
INSERT INTO products (product_name, price, stock) VALUES
('Product 1', 500000.00, 10),
('Product 2', 1500000.00, 5),      -- > 1M
('Product 3', 2000000.00, 8),      -- > 1M
('Product 4', 800000.00, 12),
('Product 5', 2500000.00, 15),     -- > 1M
('Product 6', 900000.00, 20),
('Product 7', 1200000.00, 7),      -- > 1M
('Product 8', 300000.00, 18),
('Product 9', 1750000.00, 6),      -- > 1M
('Product 10', 450000.00, 25),
('Product 11', 600000.00, 30),
('Product 12', 1100000.00, 13),    -- > 1M
('Product 13', 700000.00, 11),
('Product 14', 950000.00, 14),
('Product 15', 3500000.00, 6),     -- > 1M
('Product 16', 200000.00, 40),
('Product 17', 5555555.00, 8),     -- > 1M
('Product 18', 150000.00, 50),
('Product 19', 850000.00, 9),
('Product 20', 990000.00, 15);

-- 3. Tao Stored Procedure get_high_value_products de lay san pham gia > 1.000.000 VND
DELIMITER //
CREATE PROCEDURE get_high_value_products()
BEGIN
    SELECT * FROM products 
    WHERE price > 1000000.00;
END //
DELIMITER ;

-- 4. Goi Stored Procedure de kiem tra ket qua
CALL get_high_value_products();
