-- 1. Hiển thị sinh viên chưa có email (email là NULL)
SELECT * FROM students 
WHERE email IS NULL;

-- 2. Hiển thị sinh viên đã có email (email khác NULL)
SELECT * FROM students 
WHERE email IS NOT NULL;

-- 3. Hiển thị sinh viên có họ tên bắt đầu bằng chữ "Ng"
SELECT * FROM students 
WHERE student_name LIKE 'Ng%';

-- 4. Hiển thị sinh viên không phải giới tính Nam (khác 'Male')
SELECT * FROM students 
WHERE gender <> 'Male'; -- hoặc dùng != 'Male'
