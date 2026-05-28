USE module2_sql;
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_year INT NOT NULL,
    department VARCHAR(100),
    salary DECIMAL(10, 2),
    phone VARCHAR(15),
    emp_email VARCHAR(100) UNIQUE
);
-- Dữ liệu mẫu 
INSERT INTO employees (
        full_name,
        birth_year,
        department,
        salary,
        phone,
        emp_email
    )
VALUES (
        'Nguyen Hoang Anh',
        1995,
        'IT',
        15000000.00,
        '0912345678',
        'anguyen@example.com'
    ),
    (
        'Tran Thi B',
        1998,
        'HR',
        12000000.00,
        '0987654321',
        'btran@example.com'
    ),
    (
        'Le Tuan Anh',
        1990,
        'Sales',
        9500000.00,
        '0901234567',
        'clevan@example.com'
    ),
    (
        'Pham Minh D',
        1993,
        'IT',
        22000000.00,
        '0934567890',
        'dpham@example.com'
    ),
    (
        'Hoang Lan E',
        1997,
        'Marketing',
        11000000.00,
        NULL,
        'ehoang@example.com'
    ),
    (
        'Vu Hoang F',
        1992,
        'HR',
        18000000.00,
        '0945678901',
        'fvu@example.com'
    ),
    (
        'Do Thi G',
        1996,
        'IT',
        10000000.00,
        '0956789012',
        'gdo@example.com'
    ),
    (
        'Ngo Van H',
        1989,
        'Accounting',
        14000000.00,
        NULL,
        'hngo@example.com'
    ),
    (
        'Bui Thi I',
        1994,
        'IT',
        25000000.00,
        '0978901234',
        'ibui@example.com'
    ),
    (
        'Ly Van J',
        2000,
        'HR',
        4500000.00,
        '0989012345',
        'jly@example.com'
    );
-- Lương dưới 5M để test DELETE
-- ================
-- TRUY VẤN DỮ LIỆU
-- ================
-- a. Nhân viên có lương từ 10tr đến 20tr
SELECT *
FROM employees
WHERE salary BETWEEN 10000000 AND 20000000;
-- b. Nhân viên thuộc phòng ban IT hoặc HR
SELECT *
FROM employees
WHERE department IN ('IT', 'HR');
-- c. Nhân viên có họ tên chứa chữ "Anh"
SELECT *
FROM employees
WHERE full_name LIKE '%Anh%';
-- d. Nhân viên chưa có số điện thoại
SELECT *
FROM employees
WHERE phone IS NULL;
-- ======================
-- CẬP NHẬT & XÓA DỮ LIỆU
-- ======================
-- Tắt an toàn của SQL
SET SQL_SAFE_UPDATES = 0;
-- a. Tăng lương 10% cho nhân viên phòng IT
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';
-- b. Cập nhật số điện thoại        
UPDATE employees
SET phone = '0909999999'
WHERE phone IS NULL;
-- c. Xóa nhân viên có lương thấp hơn 5tr
DELETE FROM employees
WHERE salary < 5000000;
-- Bật lại an toàn của SQL
SET SQL_SAFE_UPDATES = 1;
-- Kiểm tra lại bảng sau khi UPDATE & DELETE
SELECT *
FROM employees;