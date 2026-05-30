-- 1. Tao cac bang
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    balance DECIMAL(15, 2) NOT NULL
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    from_account_id INT,
    to_account_id INT,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(account_id)
);

-- Them 10 tai khoan vao bang accounts
INSERT INTO accounts (account_id, balance) VALUES 
(1, 100000.00),
(2, 500000.00),
(3, 200000.00),
(4, 750000.00),
(5, 3000000.00),
(6, 150000.00),
(7, 900000.00),
(8, 250000.00),
(9, 1200000.00),
(10, 600000.00);

-- Kiem tra so du truoc khi giao dich
SELECT * FROM accounts WHERE account_id = 1;

-- 2. Bat dau transaction
START TRANSACTION;

-- Cong them 1.000.000 VND vao tai khoan co account_id = 1
UPDATE accounts 
SET balance = balance + 1000000.00 
WHERE account_id = 1;

-- Neu khong co loi, luu thay doi bang COMMIT
COMMIT;

-- Kiem tra so du sau khi giao dich
SELECT * FROM accounts WHERE account_id = 1;
