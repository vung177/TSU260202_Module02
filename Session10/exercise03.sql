-- 1. Tao cac bang va du lieu mau
DROP TRIGGER IF EXISTS BeforeInsertProduct;
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

-- 2. Tao Trigger BeforeInsertProduct de ngan chan quantity < 0 khi insert
DELIMITER //
CREATE TRIGGER BeforeInsertProduct
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm không thể nhỏ hơn 0.';
    END IF;
END //
DELIMITER ;

-- 3. Kiem tra trigger
-- Insert voi quantity >= 0 (Thanh cong)
INSERT INTO products (productName, quantity) VALUES ('Laptop', 10);

-- Insert voi quantity < 0 (That bai va nem ra loi)
INSERT INTO products (productName, quantity) VALUES ('Phone', -5);
