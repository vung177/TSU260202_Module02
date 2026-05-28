-- 1. Hiển thị sinh viên có năm sinh từ 2003 đến 2005
-- Chỉ hiển thị: mã sinh viên (student_id), họ tên (student_name), ngày sinh (dob)
SELECT student_id, student_name, dob 
FROM students 
WHERE YEAR(dob) BETWEEN 2003 AND 2005;

-- 2. Hiển thị sinh viên có giới tính là Nam hoặc Nữ (trong database lưu dưới dạng 'Male' hoặc 'Female')
-- Chỉ hiển thị: mã sinh viên (student_id), họ tên (student_name), ngày sinh (dob)
SELECT student_id, student_name, dob 
FROM students 
WHERE gender IN ('Male', 'Female');

-- 3. Hiển thị sinh viên có mã sinh viên thuộc một trong các mã: SV001, SV004, SV005 (tương ứng student_id là 1, 4, 5)
-- Chỉ hiển thị: mã sinh viên (student_id), họ tên (student_name), ngày sinh (dob)
SELECT student_id, student_name, dob 
FROM students 
WHERE student_id IN (1, 4, 5);
