-- 1. Cai dat moi truong (Tao cac bang)
DROP TRIGGER IF EXISTS before_insert_employee;
DROP TRIGGER IF EXISTS after_insert_employee;
DROP TRIGGER IF EXISTS before_update_attendance;
DROP TRIGGER IF EXISTS before_delete_employee;

DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS salary_history;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Tao bang departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL
);

-- Tao bang employees
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Tao bang salaries
CREATE TABLE salaries (
    employee_id INT PRIMARY KEY,
    base_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Tao bang salary_history (Khong dung FK rang buoc de giu lai ID sau khi employee bi xoa)
CREATE TABLE salary_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT
);

-- Tao bang attendance
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    total_hours DECIMAL(5,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Them du lieu phong ban mau
INSERT INTO departments (department_name) VALUES ('Human Resources'), ('IT');


-- 2. Dinh nghia cac Trigger

-- Trigger BEFORE INSERT tren employees: Chuan hoa email
DELIMITER //
CREATE TRIGGER before_insert_employee
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    -- Neu email khong co duoi @company.com
    IF NEW.email NOT LIKE '%@company.com' THEN
        -- Neu email co chua ky tu @ thi thay the duoi email
        IF NEW.email LIKE '%@%' THEN
            SET NEW.email = CONCAT(SUBSTRING_INDEX(NEW.email, '@', 1), '@company.com');
        ELSE
            -- Neu khong co @ thi them truc tiep duoi @company.com
            SET NEW.email = CONCAT(NEW.email, '@company.com');
        END IF;
    END IF;
END //
DELIMITER ;

-- Trigger AFTER INSERT tren employees: Tao ban ghi luong mac dinh
DELIMITER //
CREATE TRIGGER after_insert_employee
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salaries (employee_id, base_salary, bonus)
    VALUES (NEW.employee_id, 10000.00, 0.00);
END //
DELIMITER ;

-- Trigger BEFORE UPDATE tren attendance: Tinh toan total_hours
DELIMITER //
CREATE TRIGGER before_update_attendance
BEFORE UPDATE ON attendance
FOR EACH ROW
BEGIN
    -- Tinh toan total_hours khi cap nhat check_out_time
    IF NEW.check_out_time IS NOT NULL THEN
        SET NEW.total_hours = ROUND(TIMESTAMPDIFF(SECOND, NEW.check_in_time, NEW.check_out_time) / 3600.0, 2);
    END IF;
END //
DELIMITER ;

-- Trigger BEFORE DELETE tren employees: Luu lich su luong khi nhan vien nghi viec
DELIMITER //
CREATE TRIGGER before_delete_employee
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    DECLARE v_old_salary DECIMAL(10,2);
    
    -- Lay luong cu tu salaries
    SELECT base_salary INTO v_old_salary FROM salaries WHERE employee_id = OLD.employee_id;
    
    -- Ghi nhan lich su nghi viec vao salary_history
    INSERT INTO salary_history (employee_id, old_salary, new_salary, reason)
    VALUES (OLD.employee_id, v_old_salary, 0.00, 'Nhân viên nghỉ việc');
END //
DELIMITER ;


-- 3. Kiem thu (Testing)

-- --- Test Case 1: Chuan hoa email va Luong mac dinh khi them nhan vien moi (BEFORE/AFTER INSERT) ---
-- Them nhan vien voi email thieu duoi
INSERT INTO employees (name, email, phone, hire_date, department_id)
VALUES ('Nguyễn Văn A', 'nguyenvana', '0912345678', '2026-05-30', 2);

-- Kiem tra xem email da duoc chuan hoa va da tu dong tao ban ghi luong chua
SELECT * FROM employees;
SELECT * FROM salaries;

-- --- Test Case 2: Tinh toan total_hours khi checkout (BEFORE UPDATE) ---
-- Diem danh check-in cho nhan vien A
INSERT INTO attendance (employee_id, check_in_time) VALUES (1, '2026-05-30 08:00:00');
SELECT * FROM attendance;

-- Check-out cho nhan vien A luc 17:30 (Thoi gian lam la 9.5 tieng)
UPDATE attendance 
SET check_out_time = '2026-05-30 17:30:00' 
WHERE attendance_id = 1;

-- Kiem tra xem total_hours da duoc tinh tu dong chua
SELECT * FROM attendance;

-- --- Test Case 3: Luu lich su luong khi nhan vien nghi viec (BEFORE DELETE) ---
-- Xoa nhan vien A khoi he thong
DELETE FROM employees WHERE employee_id = 1;

-- Kiem tra xem du lieu luong trong salaries da xoa va da luu vao salary_history chua
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM salary_history;
