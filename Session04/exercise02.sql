-- 1. Cập nhật email cho sinh viên chưa có email (ở bài 1 là sinh viên có email NULL)
UPDATE students 
SET email = 'clevan@example.com' 
WHERE email IS NULL;

-- Kiểm tra lại dữ liệu sau khi cập nhật email
SELECT * FROM students;


-- 2. Cập nhật giới tính cho sinh viên có mã sinh viên là sv005 (tương ứng student_id = 5)
-- Ở đây ta đổi giới tính của Hoang Lan E từ 'Female' thành 'Male' (hoặc 'Other')
UPDATE students 
SET gender = 'Other' 
WHERE student_id = 5;

-- Kiểm tra lại dữ liệu sau khi cập nhật giới tính
SELECT * FROM students;


-- 3. Xóa sinh viên có mã sinh viên là sv003 (tương ứng student_id = 3)
DELETE FROM students 
WHERE student_id = 3;

-- Kiểm tra lại dữ liệu sau khi xóa
SELECT * FROM students;
