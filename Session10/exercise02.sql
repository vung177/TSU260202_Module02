-- 1. Tao cac bang va du lieu mau
DROP TRIGGER IF EXISTS BeforeProductDelete;
DROP TABLE IF EXISTS inventoryChanges;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE inventoryChanges (
    changeID INT AUTO_INCREMENT PRIMARY KEY,
    productID INT NOT NULL,
    oldQuantity INT,
    newQuantity INT,
    changeDate DATETIME NOT NULL,
    FOREIGN KEY (productID) REFERENCES products(productID)
);

INSERT INTO products (productName, quantity) VALUES 
('Laptop', 15), -- So luong > 10 (Khong the xoa)
('Phone', 5);   -- So luong <= 10 (Co the xoa)

-- 2. Tao Trigger BeforeProductDelete ngan chan xoa san pham neu quantity > 10
DELIMITER //
CREATE TRIGGER BeforeProductDelete
BEFORE DELETE ON products
FOR EACH ROW
BEGIN
    IF OLD.quantity > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa sản phẩm có số lượng lớn hơn 10.';
    END IF;
END //
DELIMITER ;

-- 3. Kiem tra xoa san pham
SET SQL_SAFE_UPDATES = 0;

-- Xoa san pham co so luong <= 10 (Thanh cong)
DELETE FROM products WHERE productID = 2;

-- Xoa san pham co so luong > 10 (That bai va nem ra loi)
DELETE FROM products WHERE productID = 1;

SET SQL_SAFE_UPDATES = 1;
