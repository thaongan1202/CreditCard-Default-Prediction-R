# 🏦 Dự đoán Khả năng Vỡ nợ Thẻ Tín dụng
### Credit Card Default Prediction — Đồ án Kết thúc môn Lập trình R cho Phân tích Dữ liệu

![R](https://img.shields.io/badge/Language-R%204.x-276DC3?style=flat&logo=r)
![Dataset](https://img.shields.io/badge/Dataset-UCI%20Credit%20Card-orange)
![Observations](https://img.shields.io/badge/Observations-30%2C000-green)
![Models](https://img.shields.io/badge/Models-3%20Classification-blue)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📋 Mục lục

- [Tổng quan dự án](#tổng-quan-dự-án)
- [Câu hỏi nghiên cứu](#câu-hỏi-nghiên-cứu)
- [Tập dữ liệu](#tập-dữ-liệu)
- [Phương pháp](#phương-pháp)
- [Kết quả nổi bật](#kết-quả-nổi-bật)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Hướng dẫn chạy](#hướng-dẫn-chạy)
- [Thành viên nhóm](#thành-viên-nhóm)
- [Tham khảo](#tham-khảo)

---

## 🎯 Tổng quan dự án

Trong lĩnh vực tài chính ngân hàng, khả năng dự đoán sớm nguy cơ vỡ nợ của khách hàng thẻ tín dụng mang ý nghĩa chiến lược quan trọng: giúp tổ chức tín dụng chủ động quản lý rủi ro, tối ưu hóa danh mục cho vay và giảm thiểu tổn thất tài chính.

Dự án này sử dụng ngôn ngữ **R** để phân tích toàn diện bộ dữ liệu khách hàng thẻ tín dụng tại Đài Loan, bao gồm:

- Tiền xử lý dữ liệu và xây dựng đặc trưng có ý nghĩa tài chính
- Phân tích dữ liệu khám phá (EDA) để phát hiện các yếu tố rủi ro
- Xây dựng và so sánh ba mô hình phân loại: **Hồi quy Logistic**, **Cây quyết định** và **Random Forest**
- Đề xuất chiến lược cảnh báo sớm cho ngân hàng dựa trên kết quả phân tích

---

## ❓ Câu hỏi nghiên cứu

Dự án tập trung giải quyết ba câu hỏi chính:

1. **Yếu tố rủi ro nào có liên quan mạnh nhất đến khả năng vỡ nợ?**  
   → Trả lời qua EDA và hệ số Odds Ratio từ Hồi quy Logistic.

2. **Mô hình phân loại nào cho hiệu suất dự đoán tốt nhất trên tập dữ liệu này?**  
   → Trả lời qua so sánh AUC-ROC, Sensitivity và F1-score của ba mô hình.

3. **Biến đầu vào nào quan trọng nhất đối với quyết định phân loại?**  
   → Trả lời qua Feature Importance của Random Forest.

---

## 📊 Tập dữ liệu

| Thuộc tính | Thông tin |
|---|---|
| **Tên** | Default of Credit Card Clients Dataset |
| **Nguồn** | [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients) |
| **Tác giả gốc** | I-Cheng Yeh (2009) |
| **Số quan sát** | 30.000 khách hàng |
| **Số biến** | 25 (24 biến độc lập + 1 biến mục tiêu) |
| **Biến mục tiêu** | `default.payment.next.month` (0 = Không vỡ nợ, 1 = Vỡ nợ) |
| **Tỷ lệ vỡ nợ** | 22.12% (mất cân bằng lớp cần xử lý) |
| **Giai đoạn** | Tháng 4–9 năm 2005 |

### Nhóm biến chính

| Nhóm | Biến | Mô tả |
|---|---|---|
| Nhân khẩu học | SEX, EDUCATION, MARRIAGE, AGE | Giới tính, học vấn, hôn nhân, tuổi |
| Tài chính | LIMIT_BAL | Hạn mức tín dụng (NT$) |
| Lịch sử thanh toán | PAY_0 → PAY_6 | Tình trạng thanh toán tháng 9→4/2005 |
| Dư nợ sao kê | BILL_AMT1 → BILL_AMT6 | Số dư tháng 9→4/2005 (NT$) |
| Số tiền đã trả | PAY_AMT1 → PAY_AMT6 | Thanh toán tháng 9→4/2005 (NT$) |

> Xem mô tả chi tiết tại [`data/data_dictionary.md`](data/data_dictionary.md)

---

## 🔬 Phương pháp

### Pipeline phân tích

```
UCI_Credit_Card.csv
        ↓
  Tiền xử lý dữ liệu
  (Xử lý giá trị bất thường trong biến phân loại,
   chuyển đổi kiểu dữ liệu, loại bỏ ID)
        ↓
  Feature Engineering
  (MAX_DELAY, UTILIZATION_RATE, AVG_PAY_AMT, REPAY_RATIO)
        ↓
  Phân tích dữ liệu khám phá (EDA)
  (Đơn biến, đa biến, ma trận tương quan)
        ↓
  Chia dữ liệu Train/Test (75%/25%, Stratified)
  + Xử lý mất cân bằng lớp (ROSE)
        ↓
  Xây dựng 3 mô hình phân loại
        ↓
  Đánh giá & So sánh (AUC, Sensitivity, F1)
        ↓
  Kết luận & Đề xuất
```

### Ba mô hình phân loại

| Mô hình | Thư viện R | Vai trò trong dự án |
|---|---|---|
| Hồi quy Logistic | `stats::glm()` | Baseline — có thể diễn giải Odds Ratio |
| Cây quyết định | `rpart` | Trực quan — giải thích được cho người không chuyên |
| Random Forest | `randomForest` | Hiệu suất cao — cung cấp Feature Importance |

### Chỉ số đánh giá

Vì bài toán vỡ nợ là **asymmetric** (bỏ sót người vỡ nợ tốn kém hơn cảnh báo nhầm), dự án ưu tiên:

- **Sensitivity (Recall)** — Khả năng phát hiện đúng người thực sự vỡ nợ
- **AUC-ROC** — Khả năng phân biệt tổng thể giữa hai lớp
- **F1-score** — Cân bằng giữa Precision và Recall

Accuracy **không** được dùng làm chỉ số chính vì dữ liệu mất cân bằng (78:22).

---

## 📈 Kết quả nổi bật

| Mô hình | Accuracy | Sensitivity | AUC | F1-score |
|---|---|---|---|---|
| Hồi quy Logistic | 72.15% | 67.81% | 0.7541 | 0.5186 |
| Cây quyết định | **76.31%** | 60.76% | 0.7378 | **0.5315** |
| **Random Forest** | 72.73% | 66.91% | **0.7667** | 0.5205 |

### Nhận xét

- Cả ba mô hình đều đạt AUC lớn hơn 0.7, cho thấy khả năng dự đoán ở mức khá.
- Cây quyết định đạt Accuracy cao nhất (76.31%) nhưng có Sensitivity thấp nhất, cho thấy mô hình bỏ sót nhiều trường hợp vỡ nợ hơn.
- Hồi quy Logistic cho kết quả tương đối cân bằng và có ưu điểm dễ giải thích.
- Random Forest đạt AUC cao nhất (0.7667), cho thấy khả năng phân biệt khách hàng vỡ nợ và không vỡ nợ tốt nhất trong ba mô hình.
- Nhóm lựa chọn **Random Forest** là mô hình phù hợp nhất cho bài toán dự đoán khả năng vỡ nợ thẻ tín dụng.

### Phát hiện chính từ EDA

- **Lịch sử thanh toán là yếu tố rủi ro mạnh nhất:**  
  Khi `PAY_0 = 2` (trễ 2 tháng), tỷ lệ vỡ nợ lên tới **69.1%**. Khi `PAY_0 = 3`, lên tới **75.8%**.

- **Hạn mức tín dụng thấp đi kèm rủi ro cao hơn:**  
  Nhóm hạn mức thấp nhất (Q1) có tỷ lệ vỡ nợ **31.8%**, cao hơn gấp đôi nhóm hạn mức cao nhất (Q4: 14.0%).

- **Random Forest cho hiệu suất tốt nhất:**  
  Mô hình đạt AUC = **0.7667**, cao nhất trong ba mô hình được thử nghiệm.

- **Đa cộng tuyến trong nhóm BILL_AMT:**  
  Sáu biến `BILL_AMT1–6` có hệ số tương quan cao và được tổng hợp thành biến `UTILIZATION_RATE` trong quá trình Feature Engineering.
---

## 📁 Cấu trúc dự án

```
credit-card-default-prediction/
│
├── README.md                      ← Tài liệu tổng quan (file này)
├── Main_Report.Rmd                ← File Rmarkdown chính — chạy để reproduce
├── Main_Report.html               ← Báo cáo đã render (xem trực tiếp)
│
├── data/
│   ├── UCI_Credit_Card.csv        ← Dataset gốc (30.000 × 25)
│   └── data_dictionary.md        ← Mô tả chi tiết 25 biến
│
└── docs/
    ├── Bao_Cao_Word.docx          ← Báo cáo Word (nộp giáo viên)
    └── Slide_Thuyet_Trinh.pptx   ← Slide thuyết trình
```

---

## 🚀 Hướng dẫn chạy

### Yêu cầu

- **R** phiên bản 4.0 trở lên  
- **RStudio** (khuyến nghị) hoặc bất kỳ IDE nào hỗ trợ R Markdown

### Các bước thực hiện

**Bước 1 — Clone repository:**
```bash
git clone https://github.com/thaongan1202/CreditCard-Default-Prediction-R.git
cd CreditCard-Default-Prediction-R
```

**Bước 2 — Cài đặt thư viện:** Mở R/RStudio và chạy lệnh sau (chỉ cần làm một lần):
```r
install.packages("pacman")
pacman::p_load(dplyr, tidyr, ggplot2, patchwork, corrplot,
               caret, pROC, rpart, rpart.plot, randomForest,
               ROSE, car, knitr, kableExtra)
```

**Bước 3 — Render báo cáo:** Mở `Main_Report.Rmd` trong RStudio và nhấn **Knit**, hoặc chạy trong Console:
```r
rmarkdown::render("Main_Report.Rmd", output_format = "html_document")
```

**Lưu ý:** Bước Random Forest có thể mất 2–5 phút tùy cấu hình máy. Toàn bộ pipeline được thiết kế để chạy từ đầu đến cuối **không cần thao tác thủ công**.

---

## 👥 Thành viên nhóm

| STT | Thành viên | MSSV | Nhiệm vụ chính |
|---|---|---|---|
| 1 | Lâm Ngọc Yến Vy | 24133076 | Tiền xử lý dữ liệu, Feature Engineering |
| 2 | Trần Thị Quế Trân | 24133067 | EDA, Trực quan hóa dữ liệu |
| 3 | Tô Thuỷ Tiên | 24133062 | Mô hình Logistic Regression, Decision Tree |
| 4 | Phạm Thị Thảo Ngân | 24133041 | Random Forest, Tích hợp & QA, README |

---

## 📚 Tham khảo

- **Dataset gốc:**  
  Yeh, I. C., & Lien, C. H. (2009). The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients. *Expert Systems with Applications*, 36(2), 2473–2480.

- **Tài liệu R:**  
  Wickham, H., & Grolemund, G. (2017). *R for Data Science*. O'Reilly Media.  
  [https://r4ds.had.co.nz](https://r4ds.had.co.nz)

- **Tài liệu môn học:**  
  Tài liệu hướng dẫn môn Lập trình R cho Phân tích Dữ liệu — HCMUTE

---

<div align="center">

*Đồ án môn học | Lập trình R cho Phân tích Dữ liệu | HCMUTE*

</div>
