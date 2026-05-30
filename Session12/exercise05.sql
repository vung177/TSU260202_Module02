-- 1. Cai dat moi truong (Tao cac bang va trigger ho tro)
DROP TRIGGER IF EXISTS before_insert_employee;
DROP TRIGGER IF EXISTS after_insert_employee;
DROP TRIGGER IF EXISTS before_delete_employee;
DROP PROCEDURE IF EXISTS IncreaseSalary;
DROP PROCEDURE IF EXISTS DeleteEmployee;

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

-- Tao bang salary_history (Khong dung FK de giu lai thong tin sau khi employee bi xoa)
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

-- Trigger de tu dong tao luong mac dinh khi them nhan vien
DELIMITER //
CREATE TRIGGER after_insert_employee
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salaries (employee_id, base_salary, bonus)
    VALUES (NEW.employee_id, 10000.00, 0.00);
END //
DELIMITER ;

-- Trigger tu dong luu lich su luong khi xoa nhan vien (nghi viec)
DELIMITER //
CREATE TRIGGER before_delete_employee
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    DECLARE v_old_salary DECIMAL(10,2);
    
    -- Lay luong cu cua nhan vien sap bi xoa
    SELECT base_salary INTO v_old_salary FROM salaries WHERE employee_id = OLD.employee_id;
    
    -- Luu vao lich su
    INSERT INTO salary_history (employee_id, old_salary, new_salary, reason)
    VALUES (OLD.employee_id, v_old_salary, 0.00, 'Nhân viên nghỉ việc');
END //
DELIMITER ;


-- 2. Viet cac Stored Procedure theo yeu cau

-- Stored Procedure IncreaseSalary
DELIMITER //
CREATE PROCEDURE IncreaseSalary(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10, 2),
    IN p_reason TEXT
)
BEGIN
    DECLARE v_old_salary DECIMAL(10, 2);
    DECLARE v_exists INT;

    -- Co che tu dong rollback khi xay ra bat ky loi SQL nao
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi hệ thống: Không thể thực hiện tăng lương.';
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Kiem tra nhan vien co ton tai
    SELECT COUNT(*) INTO v_exists FROM employees WHERE employee_id = p_emp_id;

    IF v_exists = 0 THEN
        -- Neu khong ton tai, rollback va bao loi
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Nhân viên không tồn tại.';
    ELSE
        -- Lay luong hien tai lam old_salary
        SELECT base_salary INTO v_old_salary FROM salaries WHERE employee_id = p_emp_id;

        -- 1. Cap nhat luong moi vao bang salaries
        UPDATE salaries 
        SET base_salary = p_new_salary 
        WHERE employee_id = p_emp_id;

        -- 2. Ghi nhan lich su thay doi vao salary_history
        INSERT INTO salary_history (employee_id, old_salary, new_salary, reason)
        VALUES (p_emp_id, v_old_salary, p_new_salary, p_reason);

        -- Commit giao dich
        COMMIT;
    END IF;
END //
DELIMITER ;


-- Stored Procedure DeleteEmployee
DELIMITER //
CREATE PROCEDURE DeleteEmployee(
    IN p_emp_id INT
)
BEGIN
    DECLARE v_exists INT;

    -- Co che tu dong rollback khi xay ra bat ky loi SQL nao
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi hệ thống: Không thể thực hiện xóa nhân viên.';
    END;

    -- Bat dau giao dich
    START TRANSACTION;

    -- Kiem tra nhan vien co ton tai
    SELECT COUNT(*) INTO v_exists FROM employees WHERE employee_id = p_emp_id;

    IF v_exists = 0 THEN
        -- Neu khong ton tai, rollback va bao loi
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Nhân viên không tồn tại.';
    ELSE
        -- 1. Xoa nhan vien khoi employees (salaries va attendance se duoc xoa qua CASCADE)
        -- Trigger before_delete_employee se tu dong ghi nhan lich su luong 'Nhân viên nghỉ việc' vao salary_history
        DELETE FROM employees WHERE employee_id = p_emp_id;

        -- Commit giao dich
        COMMIT;
    END IF;
END //
DELIMITER ;


-- 3. Kiem thu (Testing)

-- Them nhan vien ban dau (Tu dong tao luong 10.000)
INSERT INTO employees (name, email, phone, hire_date, department_id)
VALUES ('Nguyễn Văn A', 'nguyenvana@company.com', '0912345678', '2026-05-30', 2);
SELECT * FROM employees;
SELECT * FROM salaries;

-- --- Test Case 1: Tang luong thanh cong (IncreaseSalary) ---
CALL IncreaseSalary(1, 15000.00, 'Tăng lương định kỳ năm 2026');

-- Kiem tra lai bang salaries va salary_history
SELECT * FROM salaries;
SELECT * FROM salary_history;

-- --- Test Case 2: Xoa nhan vien thanh cong (DeleteEmployee) ---
CALL DeleteEmployee(1);

-- Kiem tra lai cac bang (Nhan vien va luong da xoa, nhung lich su luong luu tru thong tin nghi viec van con)
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM salary_history;
