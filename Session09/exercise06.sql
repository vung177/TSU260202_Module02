-- 1. Tao cac bang va du lieu mau de kiem tra doc lap
DROP PROCEDURE IF EXISTS add_order;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(15, 2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount DECIMAL(15, 2) NOT NULL CHECK (total_amount > 0),
    status ENUM('Pending', 'Success', 'Cancel') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_name, email, phone, address) VALUES
('Alice', 'alice@example.com', '1234567890', 'Ha Noi');

INSERT INTO products (product_name, price, stock) VALUES
('Product 1', 2000000.00, 10);

-- 2. Tao Stored Procedure add_order
DELIMITER //
CREATE PROCEDURE add_order(
    IN _customer_id INT,
    IN _product_id INT,
    IN _quantity INT,
    OUT _message VARCHAR(255)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(15, 2);
    
    -- Lay thong tin so luong ton kho va gia cua san pham
    SELECT stock, price INTO v_stock, v_price 
    FROM products 
    WHERE product_id = _product_id;
    
    -- Kiem tra ton kho
    IF v_stock IS NULL THEN
        SET _message = 'Sản phẩm không tồn tại.';
    ELSEIF v_stock < _quantity THEN
        SET _message = 'Không đủ số lượng sản phẩm để đặt hàng.';
    ELSE
        -- Them don hang moi
        INSERT INTO orders (customer_id, product_id, quantity, total_amount, status)
        VALUES (_customer_id, _product_id, _quantity, _quantity * v_price, 'Success');
        
        -- Cap nhat giam so luong ton kho cua san pham
        UPDATE products 
        SET stock = stock - _quantity 
        WHERE product_id = _product_id;
        
        SET _message = 'Thêm đơn hàng thành công!';
    END IF;
END //
DELIMITER ;

-- 3. Goi Stored Procedure kiem tra khi THEM MOI DON HANG THANH CONG
SET @message = '';
CALL add_order(1, 1, 5, @message);
SELECT @message AS result_message;

-- 4. Goi Stored Procedure kiem tra khi THEM MOI DON HANG THAT BAI (so luong vuot ton kho)
SET @message = '';
CALL add_order(1, 1, 500, @message);
SELECT @message AS result_message;
