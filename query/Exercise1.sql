-- a. Truy vấn cơ bản
-- 1. Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) của tất cả các cầu thủ’
SELECT MACT, HOTEN, VITRI, NGAYSINH, SO, DIACHI
FROM CAUTHU;

-- 2. Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ
SELECT * FROM CAUTHU
WHERE SO = '7' AND VITRI = N'Tiền vệ';

-- 3. Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luyện viên
SELECT TENHLV, NGAYSINH, DIACHI, DIENTHOAI FROM HUANLUYENVIEN;

-- 4. Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộ Becamex Bình Dương
SELECT * FROM CAULACBO, CAUTHU, QUOCGIA
WHERE CAULACBO.MACLB = CAUTHU.MACLB AND CAUTHU.MAQG = QUOCGIA.MAQG 
AND QUOCGIA.TENQG = N'Việt Nam' AND CAULACBO.TENCLB = N'BECAMEX BÌNH DƯƠNG';

-- 5. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng ‘SHB Đà Nẵng’ có quốc tịch “Bra-xin”
SELECT MACT, HOTEN, NGAYSINH, DIACHI, VITRI FROM CAULACBO, CAUTHU, QUOCGIA
WHERE CAULACBO.MACLB = CAUTHU.MACLB AND CAUTHU.MAQG = QUOCGIA.MAQG 
AND QUOCGIA.TENQG = N'Bra-xin' AND CAULACBO.TENCLB = N'SHB Đà Nẵng';

-- 6.  Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là “Long An”
SELECT CAUTHU.* FROM CAULACBO, CAUTHU, SANVD
WHERE CAULACBO.MACLB = CAUTHU.MACLB AND SANVD.MASAN = CAULACBO.MASAN AND SANVD.TENSAN = 'Long An'

-- 7. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 2 của mùa bóng năm 2009
SELECT TRANDAU.MATRAN, TRANDAU.NGAYTD,  SANVD.TENSAN, CLB1.TENCLB, CLB2.TENCLB, TRANDAU.KETQUA 
FROM TRANDAU, SANVD, CAULACBO CLB1, CAULACBO CLB2
WHERE TRANDAU.MASAN = SANVD.MASAN AND TRANDAU.MACLB1 = CLB1.MACLB AND CLB2.MACLB = TRANDAU.MACLB1 AND TRANDAU.VONG = '2';

-- 8. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang 
-- làm veiecj của các huấn luyện viên có quốc tịch “ViệtNam"
SELECT HUANLUYENVIEN.MAHLV, HUANLUYENVIEN.TENHLV, HUANLUYENVIEN.NGAYSINH, 
	   HUANLUYENVIEN.DIACHI, HLV_CLB.VAITRO, CAULACBO.TENCLB
FROM HUANLUYENVIEN, QUOCGIA, HLV_CLB, CAULACBO
WHERE HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV AND HLV_CLB.MACLB = CAULACBO.MACLB AND QUOCGIA.MAQG = HUANLUYENVIEN.MAQG
AND QUOCGIA.TENQG = N'Việt Nam';

-- 9. Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009
SELECT TOP 3 CAULACBO.TENCLB FROM BANGXH, CAULACBO
WHERE CAULACBO.MACLB = BANGXH.MACLB AND VONG = '3'

-- 10. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc
-- mà câu lạc bộ đó đóng ở tỉnh Binh Dương
SELECT HLV.MAHLV, HLV.TENHLV, HLV.NGAYSINH, HLV.DIACHI, HLV_CLB.VAITRO, CAULACBO.TENCLB
FROM HUANLUYENVIEN HLV, HLV_CLB, CAULACBO, TINH
WHERE HLV.MAHLV = HLV_CLB .MAHLV AND HLV_CLB.MACLB = CAULACBO.MACLB AND TINH.MATINH = CAULACBO.MATINH
AND TINH.TENTINH = N'Bình Dương';

-- b. Các phép toán trên nhóm
-- 1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ
SELECT CAULACBO.TENCLB ,COUNT(MACT) FROM CAULACBO, CAUTHU
WHERE CAULACBO.MACLB = CAUTHU.MACLB
GROUP BY CAULACBO.TENCLB;

-- 2. Thống kê số lượng cầu thủ nước ngoài (không có quốc tịch Việt Nam) của mỗi câu lạc bộ
SELECT CLB.TENCLB, COUNT(mact) FROM CAULACBO CLB, CAUTHU, QUOCGIA
WHERE CLB.MACLB = CAUTHU.MACLB AND QUOCGIA.MAQG = CAUTHU.MAQG 
AND QUOCGIA.TENQG NOT IN (N'Việt Nam')
GROUP BY CLB.TENCLB

-- 3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
-- nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.
SELECT CLB.MACLB, CLB.TENCLB, SANVD.TENSAN, CAUTHU.DIACHI, COUNT(MACT) SOCAUTHU
FROM CAULACBO CLB, CAUTHU, QUOCGIA, SANVD
WHERE CLB.MACLB = CAUTHU.MACLB AND QUOCGIA.MAQG = CAUTHU.MAQG AND SANVD.MASAN = CLB.MASAN
AND QUOCGIA.TENQG NOT IN (N'Việt Nam')
GROUP BY CLB.MACLB, CLB.TENCLB, SANVD.TENSAN, CAUTHU.DIACHI
HAVING COUNT(CAUTHU.MACT) >= 2;

-- 4. Cho biết tên tỉnh, số lượng cầu thủ đang t hi đấu ở vị trí tiền đạo trong các câu lạc
-- bộ thuộc địa bàn tỉnh đó quản ly
SELECT TENTINH, COUNT(MACT) SOCAUTHU FROM CAUTHU, CAULACBO CLB, TINH
WHERE CAUTHU.MACLB = CLB.MACLB AND TINH.MATINH = CLB.MATINH AND VITRI = N'Tiền đạo'
GROUP BY TENTINH;

-- 5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng vòng 3, năm 2009
SELECT TENCLB, TENTINH  FROM CAULACBO CLB, TINH, BANGXH
WHERE CLB.MATINH = TINH.MATINH AND CLB.MACLB = BANGXH.MACLB 
AND VONG = '3' AND HANG = '1' AND NAM = '2009';

-- c. Các toán tử nâng cao
-- 1.  Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa có số điện thoại
SELECT * FROM CAULACBO CLB, HLV_CLB, HUANLUYENVIEN HLV
WHERE CLB.MACLB = HLV_CLB.MACLB AND HLV_CLB.MAHLV = HLV.MAHLV 
AND VAITRO IS NOT NULL AND DIENTHOAI IS NULL

-- 2.  Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào
SELECT * FROM HUANLUYENVIEN HLV LEFT JOIN HLV_CLB
ON HLV_CLB.MAHLV = HLV.MAHLV INNER JOIN QUOCGIA
ON QUOCGIA.MAQG = HLV.MAQG
WHERE MACLB IS NULL;

-- 3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 lớn hơn 6 hoặc nhỏ hơn 3
SELECT HOTEN FROM BANGXH XH, CAULACBO CLB, CAUTHU CT
WHERE XH.MACLB = CLB.MACLB AND CT.MACLB = CLB.MACLB
AND (HANG > 6 OR HANG < 3) AND VONG = '3'

-- 4. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
-- của câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009 .
SELECT NGAYTD, TENSAN, CLB1.TENCLB TENCLB1, CLB2.TENCLB CLB2, KETQUA
FROM CAULACBO CLB1, CAULACBO CLB2, TRANDAU TD, SANVD
WHERE CLB1.MACLB = TD.MACLB1 AND TD.MACLB2 = CLB2.MACLB AND TD.MASAN = SANVD.MASAN
AND TD.VONG <='3' AND 
(
CLB1.MACLB = (SELECT BANGXH.MACLB FROM BANGXH WHERE VONG = '3' AND HANG = '1')
OR 
CLB2.MACLB = (SELECT BANGXH.MACLB FROM BANGXH WHERE VONG = '3' AND HANG = '1')
);
								