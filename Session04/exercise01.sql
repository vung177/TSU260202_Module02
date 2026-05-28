USE module2_sql;
-- 1. Thêm email vào bảng students đã có sẵn từ Session 2 (Bài 1)
ALTER TABLE students
ADD COLUMN email VARCHAR(100) NULL;
-- 2. Thêm 5 sinh viên (sử dụng đúng tên cột full_name và date_of_birth từ Session 2)
INSERT INTO students (full_name, date_of_birth, gender, email)
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
-- 3. Lấy danh sách sinh viên (hiển thị student_id, full_name, email)
SELECT student_id,
    full_name,
    email
FROM students;