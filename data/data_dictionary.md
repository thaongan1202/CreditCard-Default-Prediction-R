# Data Dictionary

## Dataset Information

| Thuộc tính    | Giá trị                         |
| ------------- | ------------------------------- |
| Dataset       | Default of Credit Card Clients  |
| Số quan sát   | 30,000                          |
| Số biến       | 25                              |
| Biến mục tiêu | `default.payment.next.month`    |
| Nguồn         | UCI Machine Learning Repository |

---

## Variable Description

| Biến                       | Mô tả                                      |
| -------------------------- | ------------------------------------------ |
| ID                         | Mã định danh khách hàng                    |
| LIMIT_BAL                  | Hạn mức tín dụng được cấp (NT$)            |
| SEX                        | Giới tính (1 = Nam, 2 = Nữ)                |
| EDUCATION                  | Trình độ học vấn                           |
| MARRIAGE                   | Tình trạng hôn nhân                        |
| AGE                        | Tuổi của khách hàng                        |
| PAY_0                      | Tình trạng thanh toán tháng 09/2005        |
| PAY_2                      | Tình trạng thanh toán tháng 08/2005        |
| PAY_3                      | Tình trạng thanh toán tháng 07/2005        |
| PAY_4                      | Tình trạng thanh toán tháng 06/2005        |
| PAY_5                      | Tình trạng thanh toán tháng 05/2005        |
| PAY_6                      | Tình trạng thanh toán tháng 04/2005        |
| BILL_AMT1                  | Số dư sao kê tháng 09/2005                 |
| BILL_AMT2                  | Số dư sao kê tháng 08/2005                 |
| BILL_AMT3                  | Số dư sao kê tháng 07/2005                 |
| BILL_AMT4                  | Số dư sao kê tháng 06/2005                 |
| BILL_AMT5                  | Số dư sao kê tháng 05/2005                 |
| BILL_AMT6                  | Số dư sao kê tháng 04/2005                 |
| PAY_AMT1                   | Số tiền thanh toán trong tháng 09/2005     |
| PAY_AMT2                   | Số tiền thanh toán trong tháng 08/2005     |
| PAY_AMT3                   | Số tiền thanh toán trong tháng 07/2005     |
| PAY_AMT4                   | Số tiền thanh toán trong tháng 06/2005     |
| PAY_AMT5                   | Số tiền thanh toán trong tháng 05/2005     |
| PAY_AMT6                   | Số tiền thanh toán trong tháng 04/2005     |
| default.payment.next.month | Biến mục tiêu (1 = Vỡ nợ, 0 = Không vỡ nợ) |

---

## Meaning of PAY_X Variables

Các biến `PAY_0`, `PAY_2`, `PAY_3`, `PAY_4`, `PAY_5`, `PAY_6` biểu diễn tình trạng thanh toán của khách hàng:

| Giá trị | Ý nghĩa                    |
| ------- | -------------------------- |
| -2      | Không sử dụng tín dụng     |
| -1      | Thanh toán đầy đủ đúng hạn |
| 0       | Thanh toán đúng hạn        |
| 1       | Trễ 1 tháng                |
| 2       | Trễ 2 tháng                |
| 3       | Trễ 3 tháng                |
| 4       | Trễ 4 tháng                |
| 5       | Trễ 5 tháng                |
| 6       | Trễ 6 tháng                |
| 7       | Trễ 7 tháng                |
| 8       | Trễ 8 tháng                |
| 9       | Trễ từ 9 tháng trở lên     |

---

## Target Variable

| Giá trị | Ý nghĩa                                      |
| ------- | -------------------------------------------- |
| 0       | Khách hàng không vỡ nợ trong tháng tiếp theo |
| 1       | Khách hàng vỡ nợ trong tháng tiếp theo       |

Biến này là mục tiêu dự đoán của toàn bộ dự án.

---

## Notes

* Đơn vị tiền tệ trong bộ dữ liệu là **New Taiwan Dollar (NT$)**.
* Các biến `BILL_AMT*` biểu diễn số dư trên sao kê thẻ tín dụng.
* Các biến `PAY_AMT*` biểu diễn số tiền khách hàng đã thanh toán.
* Các biến `PAY_*` phản ánh lịch sử thanh toán và là nhóm biến quan trọng nhất trong việc dự đoán khả năng vỡ nợ.
* Trong quá trình phân tích, biến `ID` được loại bỏ vì không mang ý nghĩa dự đoán.
