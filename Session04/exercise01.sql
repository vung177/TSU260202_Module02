-- Tắt foreign_key để có thể xoá bảng
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS students;
-- Tạo lại bảng students mới với cấu trúc mới
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    email VARCHAR(100) NULL
);
-- Bật lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;
-- Thêm ít nhất 5 sinh viên (trong đó có 1 sinh viên chưa có email)
INSERT INTO students (student_name, dob, gender, email)
VALUES (
        'Nguyen Van A',
        '2002-05-15',
        'Male',
        'anguyen@example.com'
    ),
    (
        'Tran Thi B',
        '2003-09-20',
        'Female',
        'btran@example.com'
    ),
    ('Le Van C', '2001-11-02', 'Male', NULL),
    -- Sinh viên không có email
    (
        'Pham Minh D',
        '2002-01-30',
        'Male',
        'dpham@example.com'
    ),
    (
        'Hoang Lan E',
        '2004-07-12',
        'Female',
        'ehoang@example.com'
    );
-- Hiển thị toàn bộ danh sách sinh viên (mã sinh viên, họ tên, email)
SELECT student_id,
    student_name,
    email
FROM students;