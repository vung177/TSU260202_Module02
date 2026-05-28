-- 1. Xóa bảng cũ nếu đã tồn tại để tránh xung đột
DROP TABLE IF EXISTS students;

-- 2. Tạo bảng students với cấu trúc yêu cầu
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    email VARCHAR(100) NULL
);

-- 3. Thêm ít nhất 5 sinh viên (trong đó có 1 sinh viên không có email)
INSERT INTO students (student_name, dob, gender, email) VALUES
('Nguyen Van A', '2002-05-15', 'Male', 'anguyen@example.com'),
('Tran Thi B', '2003-09-20', 'Female', 'btran@example.com'),
('Le Van C', '2001-11-02', 'Male', NULL), -- Sinh viên không có email
('Pham Minh D', '2002-01-30', 'Male', 'dpham@example.com'),
('Hoang Lan E', '2004-07-12', 'Female', 'ehoang@example.com');

-- 4. Truy vấn hiển thị mã sinh viên, họ tên, email của toàn bộ sinh viên
SELECT student_id, student_name, email FROM students;
