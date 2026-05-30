-- 1. Tao CSDL va cac bang
DROP TRIGGER IF EXISTS AfterProductUpdate;
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

-- Them du lieu mau
INSERT INTO products (productName, quantity) VALUES 
('Laptop', 10), 
('Phone', 20);

-- 2. Tao Trigger AfterProductUpdate de ghi nhan thay doi so luong san pham
DELIMITER //
CREATE TRIGGER AfterProductUpdate
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    -- Chi ghi lai neu so luong thay doi
    IF OLD.quantity <> NEW.quantity THEN
        INSERT INTO inventoryChanges (productID, oldQuantity, newQuantity, changeDate)
        VALUES (NEW.productID, OLD.quantity, NEW.quantity, NOW());
    END IF;
END //
DELIMITER ;

-- 3. Kiem tra trigger bang cach cap nhat so luong san pham
SET SQL_SAFE_UPDATES = 0;
UPDATE products SET quantity = 15 WHERE productID = 1;
UPDATE products SET quantity = 25 WHERE productID = 2;
SET SQL_SAFE_UPDATES = 1;

-- 4. Truy van bang ghi lich su thay doi
SELECT * FROM inventoryChanges;
