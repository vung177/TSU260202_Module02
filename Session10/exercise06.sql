-- 1. Tao cac bang
DROP TRIGGER IF EXISTS before_cart_add;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(productID)
);

-- Them san pham mau "iPhone 15" voi ton kho 5 va productID = 13 de dung nhu hinh anh minh hoa
INSERT INTO products (productID, productName, quantity) VALUES (13, 'iPhone 15', 5);

-- 2. Tao Trigger before_cart_add
DELIMITER //
CREATE TRIGGER before_cart_add
BEFORE INSERT ON cart_items
FOR EACH ROW
BEGIN
    DECLARE stock_quantity INT;
    
    -- Lay so luong ton kho cua san pham dang duoc them
    SELECT quantity INTO stock_quantity FROM products WHERE productID = NEW.product_id;
    
    -- So sanh so luong khach mua voi ton kho
    IF NEW.quantity > stock_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng hàng trong kho không đủ';
    END IF;
END //
DELIMITER ;

-- 3. Kiem thu
-- Truong hop 1: Thu them vao gio hang so luong 2 (Hop le -> Thanh cong)
INSERT INTO cart_items (product_id, quantity) VALUES (13, 2);
SELECT * FROM cart_items;

-- Truong hop 2: Thu them vao gio hang so luong 10 (Khong hop le -> Phai bao loi)
INSERT INTO cart_items (product_id, quantity) VALUES (13, 10);
