-- 1. Sinh viên chưa có email
SELECT *
FROM students
WHERE email IS NULL;
-- 2. Sinh viên đã có email
SELECT *
FROM students
WHERE email IS NOT NULL;
-- 3. Sinh viên có họ tên bắt đầu bằng chữ "Ng"
SELECT *
FROM students
WHERE student_name LIKE 'Ng%';
-- 4. Sinh viên không phải giới tính Nam
SELECT *
FROM students
WHERE gender <> 'Male';
-- hoặc WHERE gender != 'Male';