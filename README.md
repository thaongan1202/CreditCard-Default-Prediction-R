# CreditCard-Default-Prediction-R
Đồ án môn Lập trình R cho phân tích - Dự đoán rủi ro vỡ nợ thẻ tín dụng


## 📂 Cấu trúc Thư mục & Hướng dẫn lưu trữ
Để dự án gọn gàng và không bị ghi đè code của nhau, các thành viên vui lòng làm việc và lưu file **ĐÚNG** vào các thư mục tương ứng dưới đây:

```text
CreditCard-Default-Prediction-R/
│
├── 📁 data/                  # NƠI CHỨA DỮ LIỆU (Chỉ lưu file .csv hoặc .xlsx)
│   ├── raw/                  # (Thành viên 1) Lưu file dữ liệu gốc tải từ Kaggle vào đây. Tuyệt đối không chỉnh sửa file này.
│   └── processed/            # (Thành viên 1) Lưu file dữ liệu sau khi đã code làm sạch vào đây. Các thành viên khác sẽ lấy file sạch từ thư mục này để chạy code.
│
├── 📁 scripts/               # NƠI CHỨA CODE R CỦA TỪNG NGƯỜI
│   ├── 01_data_cleaning.R    # (Thành viên 1) Chỉ viết code tiền xử lý ở đây.
│   ├── 02_visualization.R    # (Thành viên 2) Chỉ viết code vẽ biểu đồ ggplot2 ở đây.
│   └── 03_modeling.R         # (Thành viên 3 & 4) Chỉ viết code train các thuật toán ở đây.
│
├── 📁 report/                # NƠI CHỨA CODE BÁO CÁO TỔNG HỢP
│   └── Main_Report.Rmd       # (Thành viên 4) Gom code từ thư mục scripts/ vào đây để chạy kết xuất ra báo cáo cuối cùng.
│
├── 📁 docs/                  # NƠI LƯU TRỮ TÀI LIỆU NỘP BÀI
│   ├── Bao_cao_nhom.docx     # Cả nhóm cùng cập nhật nội dung báo cáo Word vào đây.
│   └── Slide_thuyet_trinh.pptx # Chứa file slide thuyết trình chung.