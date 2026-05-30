-- 1. Chuan bi du lieu
DROP PROCEDURE IF EXISTS deposit_with_logging;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(15, 2) NOT NULL,
    log_message VARCHAR(255) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Them tai khoan mau
INSERT INTO accounts (account_id, customer_name, balance) VALUES
(1, 'Nguyễn Văn A', 1000000.00),
(2, 'Nguyễn Văn Mão', 300000.00),
(3, 'Nguyễn Văn An', 0.00);

-- 2. Viet Stored Procedure deposit_with_logging
DELIMITER //
CREATE PROCEDURE deposit_with_logging(
    IN p_account_id INT,
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    -- Khai bao handler de rollback va thong bao loi khi co SQLEXCEPTION
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đã xảy ra lỗi, giao dịch đã được hoàn tác.';
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Buoc 1: Cap nhat cong them tien vao bang accounts
    UPDATE accounts 
    SET balance = balance + p_amount 
    WHERE account_id = p_account_id;

    -- Buoc 2: Them mot dong ghi nhan vao bang transactions
    INSERT INTO transactions (account_id, amount, log_message)
    VALUES (p_account_id, p_amount, 'Nạp tiền vào tài khoản');

    -- Commit neu suon se
    COMMIT;
END //
DELIMITER ;

-- 3. Kiem thu (Testing)
-- Goi thu tuc de nap 1.000.000 VND cho tai khoan ID = 3
CALL deposit_with_logging(3, 1000000.00);

-- Kiem tra bang accounts va transactions de xem ket qua
SELECT * FROM accounts WHERE account_id = 3;
SELECT * FROM transactions;

-- Thu goi thu tuc voi account_id khong ton tai (Gay loi khoa ngoai de test rollback)
-- CALL deposit_with_logging(9999, 1000000.00);
