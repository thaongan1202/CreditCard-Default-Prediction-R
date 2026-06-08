# 💳 # Phân tích và Dự đoán Rủi ro Vỡ nợ Thẻ tín dụng (Credit Card Default Prediction)

![R](https://img.shields.io/badge/R_Programming-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)

Đây là đồ án kết thúc môn học "Lập trình R cho Phân tích", thực hiện phân tích dữ liệu khách hàng sử dụng thẻ tín dụng nhằm hiểu rõ các đặc điểm thanh toán và xác định rủi ro vỡ nợ.

## Giới thiệu Dự án

Trong hoạt động của ngân hàng, việc kiểm soát nợ xấu từ thẻ tín dụng là một trong những ưu tiên hàng đầu. Dự án này sử dụng ngôn ngữ R và các kỹ thuật phân tích dữ liệu để:

- Mô tả và khám phá đặc điểm nhân khẩu học, thói quen chi tiêu của khách hàng.
- Tìm hiểu các yếu tố ảnh hưởng lớn nhất đến việc khách hàng trễ hạn thanh toán.
- Xây dựng mô hình phân loại (Classification) để dự đoán khả năng vỡ nợ của khách hàng trong tháng tiếp theo.

## Thành viên Nhóm

- Tô Thuỷ Tiên
- Lâm Ngọc Yến Vy
- Trần Thị Quế Trân
- Phạm Thị Thảo Ngân

## Bộ dữ liệu

Dữ liệu được sử dụng là bộ "Default of Credit Card Clients" từ nền tảng Kaggle, chứa thông tin về nhân khẩu học, lịch sử thanh toán, hóa đơn và hạn mức tín dụng của 30.000 khách hàng tại Đài Loan.

- **Nguồn:** [https://www.kaggle.com/datasets/uciml/default-of-credit-card-clients-dataset](https://www.kaggle.com/datasets/uciml/default-of-credit-card-clients-dataset)
- **File chính:** `default_of_credit_card_clients.csv` (đặt trong thư mục `data/`)

## Cấu trúc Thư mục Dự án

```text
CreditCard-Default-Prediction/
├── data/       # Chứa file dữ liệu default_of_credit_card_clients.csv
├── ref/        # Thư mục tham khảo, chứa tài liệu, rubric hướng dẫn
├── scripts/    # Chứa mã nguồn R lẻ của từng thành viên
├── report/     # Chứa file báo cáo cuối cùng (.Rmd, .docx, .pptx)
└── README.md   
```
## Quy trình Phân tích

Dự án được thực hiện qua các bước chính sau:

1. **Tiền xử lý dữ liệu:**
    * Làm sạch dữ liệu (xử lý giá trị thiếu, loại bỏ hoặc chuẩn hóa dữ liệu ngoại lai).
    * Xử lý các giá trị không hợp lệ trong biến phân loại (Học vấn, Tình trạng hôn nhân).
2. **Phân tích dữ liệu khám phá (EDA):**
    * Trực quan hóa bằng histogram, boxplot, bar chart, v.v.
    * Phân tích mối quan hệ giữa độ tuổi, hạn mức, lịch sử thanh toán với khả năng vỡ nợ.
3. **Mô hình hóa dữ liệu:**
    * **Hồi quy Logistic (Logistic Regression):** Đánh giá mối liên hệ tuyến tính và dự đoán xác suất vỡ nợ.
    * **Cây quyết định (Decision Tree):** Trực quan hóa các quy luật ra quyết định phân loại khách hàng.
    * **Rừng ngẫu nhiên (Random Forest):** Cải thiện độ chính xác và đánh giá tầm quan trọng của các biến.
4. **Đánh giá mô hình và Diễn giải kết quả:**
    * Đánh giá độ chính xác của các mô hình qua Accuracy, Precision, Recall và Confusion Matrix.
    * Phân tích ý nghĩa của các yếu tố ảnh hưởng đến quyết định vỡ nợ.
5. **Kết luận và Đề xuất:**
    * Tóm tắt phát hiện chính từ dữ liệu.
    * Đề xuất các ứng dụng để kiểm soát hạn mức thẻ tín dụng.

## Công cụ và Thư viện R chính

* **Ngôn ngữ:** R
* **IDE:** RStudio
* **Các gói R sử dụng:**
    * `dplyr`, `tidyr`: Xử lý và thao tác dữ liệu
    * `ggplot2`, `corrplot`: Trực quan hóa dữ liệu
    * `rpart`, `rpart.plot`: Phân tích và vẽ Cây quyết định
    * `randomForest`: Phân tích Rừng ngẫu nhiên
    * `caret`: Hỗ trợ đánh giá mô hình phân loại
    * `knitr`, `rmarkdown`: Tạo báo cáo

## Cách chạy Báo cáo

1. Clone repository này về máy tính.
2. Mở file `.Rproj` hoặc file `Main_Report.Rmd` trong thư mục `report/` bằng RStudio.
3. Đảm bảo đã cài đặt các thư viện R cần thiết.
4. Đặt file dữ liệu `default_of_credit_card_clients.csv` vào thư mục `data/`.
5. Nhấn Knit để tạo báo cáo (Word hoặc PDF/HTML).

## Đóng góp

Xem chi tiết đánh giá đóng góp của từng thành viên trong phần **"11. Peer Assessment"** của báo cáo Word chính.

* **Tô Thuỷ Tiên:** Tiền xử lý và làm sạch dữ liệu.
* **Lâm Ngọc Yến Vy:** Phân tích dữ liệu khám phá (EDA) và trực quan hóa.
* **Trần Thị Quế Trân:** Xây dựng mô hình Hồi quy Logistic và Cây quyết định.
* **Phạm Thị Thảo Ngân:** Xây dựng mô hình Random Forest, tổng hợp file Rmarkdown và rà soát lỗi code.

## Cam kết Học thuật

Dự án này là sản phẩm thực hành dựa trên kiến thức môn học. Toàn bộ mã nguồn, dữ liệu và tài liệu tham khảo đều được trích dẫn đầy đủ tại mục Phụ lục của báo cáo.

