-- 1. Tao bang products va du lieu mau
DROP PROCEDURE IF EXISTS sp_get_products_by_category;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    category VARCHAR(50) NOT NULL
);

INSERT INTO products (product_name, price, category) VALUES
('Laptop Dell', 15000000.00, 'Laptop'),
('iPhone 13', 14000000.00, 'Phone'),
('MacBook Air', 22000000.00, 'Laptop'),
('Samsung Galaxy S23', 18000000.00, 'Phone'),
('iPad Pro', 20000000.00, 'Tablet');

-- 2. Tao Stored Procedure voi 1 tham so IN de loc san pham theo danh muc
DELIMITER //
CREATE PROCEDURE sp_get_products_by_category(
    IN p_category VARCHAR(50)
)
BEGIN
    SELECT * FROM products 
    WHERE category = p_category;
END //
DELIMITER ;

-- 3. Goi procedure de kiem tra voi danh muc 'Laptop'
CALL sp_get_products_by_category('Laptop');
