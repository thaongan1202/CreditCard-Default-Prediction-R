# 💳 Credit Card Default Prediction (Dự đoán rủi ro vỡ nợ thẻ tín dụng)

![R](https://img.shields.io/badge/R_Programming-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-Classification-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)

Đây là đồ án kết thúc môn học **Lập trình R cho Phân tích**. Dự án ứng dụng các kỹ thuật Khai phá dữ liệu (Data Mining) và Học máy (Machine Learning) để xây dựng hệ thống cảnh báo sớm rủi ro tín dụng, hỗ trợ các tổ chức tài chính ra quyết định cấp hoặc thu hồi hạn mức thẻ tín dụng một cách tự động và tối ưu.

## 1. Bài toán Nghiệp vụ (Business Problem)
Trong quản trị rủi ro ngân hàng, nợ xấu từ thẻ tín dụng là một trong những nguyên nhân hàng đầu gây thất thoát vốn. Việc dự đoán chính xác khách hàng có khả năng vỡ nợ (Default) trong kỳ sao kê tiếp theo mang lại các giá trị thực tiễn:
- **Tối ưu hóa quản trị rủi ro:** Chủ động thu hồi nợ, đóng băng hạn mức hoặc yêu cầu tài sản đảm bảo đối với nhóm rủi ro cao.
- **Cá nhân hóa chính sách tín dụng:** Điều chỉnh hạn mức linh hoạt và thiết kế các gói lãi suất phù hợp cho từng phân khúc khách hàng.

## 2. Thông tin Dữ liệu (Dataset Overview)
Dự án sử dụng bộ dữ liệu chuẩn mực **"Default of Credit Card Clients"** từ UCI Machine Learning Repository.
- **Quy mô:** 30.000 hồ sơ khách hàng x 24 thuộc tính (Features).
- **Biến mục tiêu (Target):** `default.payment.next.month` (0 = Trả nợ đúng hạn, 1 = Vỡ nợ).
- **Từ điển dữ liệu tóm tắt:**
  - `LIMIT_BAL`: Hạn mức tín dụng được cấp.
  - `SEX`, `EDUCATION`, `MARITAL`, `AGE`: Đặc điểm nhân khẩu học.
  - `PAY_0` -> `PAY_6`: Lịch sử trễ hạn thanh toán trong 6 tháng gần nhất.
  - `BILL_AMT1` -> `BILL_AMT6`: Dư nợ trên hóa đơn 6 tháng gần nhất.

## 3. Quy trình Triển khai (Data Pipeline & R Techniques)
Dự án được thực hiện nghiêm ngặt theo luồng phân tích dữ liệu, ứng dụng các kỹ thuật lập trình R nâng cao nhằm đáp ứng các tiêu chuẩn học thuật:

* **Tiền xử lý & Kỹ thuật đặc trưng (Data Preprocessing):** * Xử lý dữ liệu khuyết thiếu (Missing values) và chuẩn hóa các giá trị ngoại lai (Outliers).
    * Ứng dụng các cấu trúc dữ liệu nâng cao (`list`, `matrix`) để gom nhóm và xử lý đồng loạt các biến số.
* **Phân tích dữ liệu khám phá (EDA):** * Sử dụng `ggplot2` để trực quan hóa dữ liệu đa chiều (Boxplot, Correlation Heatmap).
    * Rút ra các phát hiện tri thức (Business Insights) đằng sau mỗi biểu đồ về thói quen tiêu dùng.
* **Mô hình hóa (Modeling & Evaluation):**
    * Triển khai 3 mô hình Classification: **Logistic Regression** (Baseline), **Decision Tree** (Rules extraction), và **Random Forest** (Ensemble learning).
    * Xây dựng *hàm đánh giá tự định nghĩa (User-defined functions)* để tự động trích xuất và so sánh các chỉ số: *Accuracy, Precision, Recall, F1-Score, Confusion Matrix.*

## 4. Công cụ & Thư viện (Tech Stack)
Toàn bộ dự án được phát triển trên môi trường **RStudio** và kết xuất thông qua **Rmarkdown** để đảm bảo tính minh bạch của mã nguồn.
- **Data Manipulation:** `tidyverse`, `dplyr`, `tidyr`
- **Data Visualization:** `ggplot2`, `corrplot`
- **Machine Learning:** `rpart`, `rpart.plot`, `randomForest`, `caret`, `pROC`

##Phân công nhiệm vụ 
- Lâm Ngọc Yến Vy: Phụ trách Data Pipeline: Tải, làm sạch, chuẩn hóa kiểu dữ liệu và xử lý missing values.
- Trần Thị Quế Trân: Phụ trách Data Visualization: Vẽ biểu đồ, phân tích EDA và rút ra Insight nghiệp vụ.
- Tô Thuỷ Tiên: Xây dựng, huấn luyện và đánh giá mô hình Logistic Regression và Decision Tree.
- Phạm Thị Thảo Ngân: Xây dựng Random Forest, rà soát chất lượng code toàn hệ thống, ráp file Rmarkdown cuối cùng.
## 5. Tổ chức Thư mục (Repository Structure)
Nhóm áp dụng cấu trúc thư mục chuẩn cho các dự án Data Science nhằm quản lý phiên bản hiệu quả:

```text
CreditCard-Default-Prediction/
├── 📁 data/             # Nơi lưu trữ dataset (raw_data và processed_data)
├── 📁 scripts/          # Mã nguồn R lẻ cho từng công đoạn phân chia theo thành viên
├── 📁 report/           # Chứa file Main_Report.Rmd tổng hợp báo cáo và code
├── 📁 docs/             # Chứa Slide thuyết trình và Báo cáo Word chi tiết (11 mục)
├── .gitignore           # File cấu hình bỏ qua các tệp tạm của RStudio
└── README.md