-- 1. Tao cac bang va procedure
DROP PROCEDURE IF EXISTS withdraw_money;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL
);

-- Them du lieu mau
INSERT INTO accounts (account_id, customer_name, balance) VALUES
(1, 'Nguyễn Văn A', 1000000.00),
(2, 'Nguyễn Văn Mão', 300000.00),
(3, 'Trần Thị B', 500000.00);

-- 2. Viet Stored Procedure withdraw_money
DELIMITER //
CREATE PROCEDURE withdraw_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    DECLARE current_balance DECIMAL(15, 2);
    
    -- 1. START TRANSACTION: Bat dau phien giao dich
    START TRANSACTION;
    
    -- 2. UPDATE: Thuc hien tru tien trong tai khoan
    UPDATE accounts 
    SET balance = balance - p_amount 
    WHERE account_id = p_account_id;
    
    -- 3. Lay so du hien tai cua tai khoan do
    SELECT balance INTO current_balance 
    FROM accounts 
    WHERE account_id = p_account_id;
    
    -- 4. Dieu kien check balance
    IF current_balance < 0 THEN
        -- Neu so du < 0: Thuc hein ROLLBACK va thong bao
        ROLLBACK;
        SELECT 'Giao dịch thất bại! Số dư không đủ.' AS message;
    ELSE
        -- Neu so du >= 0: Thuc hien COMMIT va thong bao
        COMMIT;
        SELECT 'Rút tiền thành công' AS message;
    END IF;
END //
DELIMITER ;

-- 3. Kiem thu (Testing)
-- Truong hop 1 (That bai): Rut 500.000 tu tai khoan co 300.000 (Mong muon: van con 300.000)
CALL withdraw_money(2, 500000.00);
SELECT * FROM accounts WHERE account_id = 2;

-- Truong hop 2 (Thanh cong): Rut 100.000 tu tai khoan con 300.000 (Mong muon: con 200.000)
CALL withdraw_money(2, 100000.00);
SELECT * FROM accounts WHERE account_id = 2;
