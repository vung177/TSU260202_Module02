-- 1. Hiển thị sinh viên có năm sinh từ 2003 đến 2005
-- Chỉ hiển thị: mã sinh viên (student_id), họ tên (student_name), ngày sinh (dob)
SELECT student_id,
    student_name,
    dob
FROM students
WHERE YEAR(dob) BETWEEN 2003 AND 2005;
-- 2. Hiển thị sinh viên có giới tính là Nam hoặc Nữ
-- Chỉ hiển thị: mã sinh viên (student_id), họ tên (student_name), ngày sinh (dob)
SELECT student_id,
    student_name,
    dob
FROM students
WHERE gender IN ('Male', 'Female');
-- 3. Hiển thị sinh viên có mã sinh viên là các mã sau: SV001, SV004, SV005
-- Chỉ hiển thị: mã sinh viên (student_id), họ tên (student_name), ngày sinh (dob)
SELECT student_id,
    student_name,
    dob
FROM students
WHERE student_id IN (1, 4, 5);