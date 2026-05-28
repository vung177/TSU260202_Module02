-- 1. Thêm các cột còn thiếu vào bảng students (chỉ thêm date_of_birth và gender, không thêm email vì đã có sẵn)
ALTER TABLE students ADD COLUMN date_of_birth DATE;
ALTER TABLE students ADD COLUMN gender VARCHAR(10);

-- 2. Thêm dữ liệu vào bảng students (ít nhất 5 sinh viên, 1 sinh viên không có email)
INSERT INTO students (full_name, date_of_birth, gender, email) VALUES
('Nguyen Van A', '2002-05-15', 'Male', 'anguyen@example.com'),
('Tran Thi B', '2003-09-20', 'Female', 'btran@example.com'),
('Le Van C', '2001-11-02', 'Male', NULL),
('Pham Minh D', '2002-01-30', 'Male', 'dpham@example.com'),
('Hoang Lan E', '2004-07-12', 'Female', 'ehoang@example.com');

-- 3. Hiển thị danh sách sinh viên: mã sinh viên, họ tên, email
SELECT student_id, full_name, email FROM students;