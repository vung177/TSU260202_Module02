-- 1. Chuan bi du lieu
DROP PROCEDURE IF EXISTS transfer_money;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL
);

-- Them du lieu mau cho tai khoan gui va nhan
INSERT INTO accounts (account_id, customer_name, balance) VALUES
(4, 'Nguyễn Văn Tam', 2000000.00),
(5, 'Nguyễn Văn Tứ', 0.00);

-- 2. Viet Stored Procedure transfer_money
DELIMITER //
CREATE PROCEDURE transfer_money(
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    DECLARE sender_balance DECIMAL(15, 2);
    
    -- Khai bao handler de rollback neu co loi SQL bat ngo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại do lỗi hệ thống!' AS message;
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Lay so du cua tai khoan gui
    SELECT balance INTO sender_balance FROM accounts WHERE account_id = p_sender_id;

    -- Kiem tra dieu kien du tien
    IF sender_balance IS NULL THEN
        ROLLBACK;
        SELECT 'Tài khoản gửi không tồn tại!' AS message;
    ELSEIF sender_balance < p_amount THEN
        ROLLBACK;
        SELECT 'Số dư tài khoản gửi không đủ.' AS message;
    ELSE
        -- Tru tien nguoi gui
        UPDATE accounts 
        SET balance = balance - p_amount 
        WHERE account_id = p_sender_id;

        -- Cong tien nguoi nhan
        UPDATE accounts 
        SET balance = balance + p_amount 
        WHERE account_id = p_receiver_id;

        -- Commit giao dich
        COMMIT;
        SELECT 'Chuyển tiền thành công!' AS message;
    END IF;
END //
DELIMITER ;

-- 3. Kiem thu (Testing)
-- Thuc hien chuyen 300.000 VND tu ID 4 sang ID 5
CALL transfer_money(4, 5, 300000.00);

-- Kiem tra lai so du cua ca hai tai khoan
SELECT * FROM accounts WHERE account_id IN (4, 5);
