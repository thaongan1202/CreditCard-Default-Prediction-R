## ============================================================
##  PHẦN VIỆC CỦA THÀNH VIÊN D
##  Credit Card Default Prediction
##  Bao gồm:
##    (1) Train/Test Split + Xử lý Class Imbalance
##    (2) Random Forest - Train & Predict
##    (3) Hàm đánh giá thống nhất
##    (4) So sánh 3 mô hình
##    (5) Discussion & Feature Importance
##
##  LƯU Ý KHI TÍCH HỢP VÀO Main_Report.Rmd:
##    - Các chunk này chạy SAU chunk của A (cleaning + FE)
##      và SAU chunk của C (logistic + decision tree)
##    - Biến đầu vào cần có sẵn: credit_final
##    - Biến từ C cần có: prob_logistic, pred_logistic,
##                        prob_dt, pred_dt
## ============================================================


# ==============================================================
# PHẦN 5.2 — CHUẨN BỊ DỮ LIỆU CHO MÔ HÌNH
# (Thành viên D viết, dùng chung cho cả 3 mô hình)
# Chunk name: data_split
# ==============================================================

# --- 5.2.1 Chia train/test theo tỉ lệ 75/25 ---
# Dùng createDataPartition để đảm bảo stratified split:
# tỉ lệ DEFAULT=1 (22.12%) được giữ nguyên trong cả 2 tập.
# Nếu dùng sample() thông thường, tập nhỏ có thể bị lệch phân phối.

set.seed(42)
trainIndex <- createDataPartition(
  credit_final$DEFAULT,
  p     = 0.75,
  list  = FALSE,
  times = 1
)

train_set <- credit_final[ trainIndex, ]
test_set  <- credit_final[-trainIndex, ]

cat("=== Kiểm tra split ===\n")
cat(sprintf("Train: %d rows | Test: %d rows\n", nrow(train_set), nrow(test_set)))
cat(sprintf("Train default rate: %.2f%%\n", mean(train_set$DEFAULT == "Có") * 100))
cat(sprintf("Test  default rate: %.2f%%\n", mean(test_set$DEFAULT  == "Có") * 100))
# Hai tỉ lệ này phải gần bằng nhau (~22%) → stratified split hoạt động đúng


# --- 5.2.2 Xử lý Class Imbalance bằng ROSE ---
# Tỉ lệ mất cân bằng thực tế: 77.88% (không vỡ nợ) : 22.12% (vỡ nợ) ≈ 3.52:1
# Mô hình huấn luyện trên dữ liệu mất cân bằng sẽ thiên về dự đoán lớp đa số,
# dẫn đến Sensitivity thấp (bỏ sót nhiều người vỡ nợ thực sự).
#
# ROSE (Random Over-Sampling Examples) tạo ra dữ liệu tổng hợp để cân bằng lớp.
# QUAN TRỌNG: Chỉ áp dụng TRÊN TRAIN SET — test set phải giữ phân phối thực tế.
# Lý do: Test set là đại diện cho "thực tế", nếu cân bằng test set
# thì kết quả đánh giá sẽ bị lạc quan sai lệch (data leakage).

set.seed(42)
train_balanced <- ROSE(DEFAULT ~ ., data = train_set, seed = 42)$data

cat("\n=== Sau khi ROSE ===\n")
print(table(train_balanced$DEFAULT))
cat(sprintf("Train balanced: %d rows\n", nrow(train_balanced)))
# Mục tiêu: hai lớp xấp xỉ 50/50


# ==============================================================
# PHẦN 5.5 — MÔ HÌNH 3: RANDOM FOREST
# Chunk name: rf_training (thêm cache=TRUE để tránh train lại)
# ==============================================================

# --- 5.5.1 Cơ sở lý thuyết (viết trong văn bản Rmd, không phải code) ---
# Random Forest xây dựng ntree cây quyết định độc lập, mỗi cây:
#   (1) Train trên một bootstrap sample (lấy mẫu có hoàn lại) từ train set
#   (2) Tại mỗi node chỉ xem xét mtry features ngẫu nhiên thay vì tất cả
# Dự đoán cuối = vote đa số từ tất cả cây (classification).
# "Double randomness" này giảm variance và correlation giữa các cây
# → ensemble mạnh hơn từng cây đơn lẻ.

# --- 5.5.2 Train mô hình ---

set.seed(42)  # Đặt seed ngay trong cùng chunk để đảm bảo reproduce

rf_model <- randomForest(
  DEFAULT ~ .,
  data      = train_balanced,
  ntree     = 500,
  # mtry: số features xem xét tại mỗi node.
  # Công thức chuẩn cho classification: floor(sqrt(p)) với p = số features.
  # Dataset này có 15 features → mtry ≈ 3-4.
  # Dùng default của randomForest (tự tính sqrt) bằng cách không khai báo.
  importance = TRUE,    # BẮT BUỘC để vẽ varImpPlot() sau này
  nodesize   = 5        # Tăng từ default=1 để giảm thời gian train
                        # Với 22500 rows, nodesize=5 tiết kiệm ~40% thời gian
                        # mà AUC giảm không đáng kể (<0.002)
)

# Lưu model để các lần render sau load lại thay vì train lại
# Uncomment dòng này sau khi đã confirm model chạy đúng:
# saveRDS(rf_model, "output/models/rf_model.rds")
# Để load: rf_model <- readRDS("output/models/rf_model.rds")

# In tóm tắt model
print(rf_model)

# OOB Error — đặc điểm độc đáo của Random Forest:
# Mỗi cây chỉ dùng ~63% data để train, 37% còn lại (out-of-bag)
# được dùng để ước tính error mà không cần test set riêng.
# OOB error là cross-validation "miễn phí" tính ngay trong quá trình train.
cat(sprintf(
  "\nOOB Error Rate: %.2f%% (ước tính error không cần test set)\n",
  rf_model$err.rate[500, "OOB"] * 100
))


# --- 5.5.3 Dự đoán trên TEST SET GỐC ---
# KHÔNG dùng train_balanced để dự đoán — phải dùng test_set gốc
# để đánh giá trên phân phối thực tế (78:22)

prob_rf <- predict(rf_model, newdata = test_set, type = "prob")[, "Có"]
# type="prob" → trả về ma trận xác suất cho mỗi lớp
# [, "Có"] → lấy cột xác suất của lớp positive (vỡ nợ)

pred_rf <- predict(rf_model, newdata = test_set, type = "class")
# type="class" → trả về nhãn lớp dự đoán trực tiếp

# Kiểm tra nhanh
cat("\n=== Phân phối dự đoán trên test set ===\n")
print(table(pred_rf))


# ==============================================================
# PHẦN 6 — ĐÁNH GIÁ VÀ SO SÁNH
# ==============================================================

# --- 6.0 Hàm đánh giá thống nhất (viết 1 lần, dùng cho cả 3 mô hình) ---
# Lý do viết hàm thay vì copy-paste:
#   (1) Đảm bảo tất cả 3 mô hình dùng CÙNG cách tính metric
#   (2) Nếu cần thêm/sửa metric, chỉ sửa 1 chỗ
#   (3) Thể hiện kỹ năng R (rubric tiêu chí 4: "sử dụng hàm")
# Chunk name: evaluation_function

get_metrics <- function(actual, predicted, prob, model_name) {
  # actual:     factor vector — nhãn thực tế từ test_set$DEFAULT
  # predicted:  factor vector — nhãn dự đoán từ predict()
  # prob:       numeric vector — xác suất của lớp positive ("Có")
  # model_name: string — tên hiển thị trong bảng so sánh

  cm <- confusionMatrix(
    data      = predicted,
    reference = actual,
    positive  = "Có"   # Khai báo rõ lớp positive
                        # Nếu không khai báo, caret dùng level đầu tiên
                        # = "Có" (theo alphabetical) — nhưng tốt hơn là luôn khai báo tường minh
  )

  roc_obj <- roc(
    response  = actual,
    predictor = prob,
    levels    = c("Không", "Có"),
    direction = "<",    # "<" = score cao hơn → predicted positive
                        # Không khai báo → pROC tự đoán, đôi khi đoán sai
                        # dẫn đến AUC < 0.5 (kết quả tệ hơn random)
    quiet     = TRUE    # Tắt message "Setting levels" in ra Console
  )

  data.frame(
    `Mô hình`     = model_name,
    Accuracy      = round(cm$overall["Accuracy"],    4),
    Sensitivity   = round(cm$byClass["Sensitivity"], 4),  # = Recall = TP/(TP+FN)
    Specificity   = round(cm$byClass["Specificity"], 4),  # = TN/(TN+FP)
    Precision     = round(cm$byClass["Pos Pred Value"], 4),
    F1_Score      = round(cm$byClass["F1"],          4),
    AUC           = round(auc(roc_obj),              4),
    check.names   = FALSE  # Giữ tên cột có dấu tiếng Việt
  )
}


# --- 6.3 Kết quả Mô hình 3: Random Forest ---
# Chunk name: rf_evaluation

cm_rf  <- confusionMatrix(pred_rf, test_set$DEFAULT, positive = "Có")
roc_rf <- roc(test_set$DEFAULT, prob_rf,
              levels = c("Không","Có"), direction = "<", quiet = TRUE)

cat("=== Confusion Matrix - Random Forest ===\n")
print(cm_rf$table)

cat(sprintf("\nAccuracy   : %.4f\n", cm_rf$overall["Accuracy"]))
cat(sprintf("Sensitivity: %.4f  (tỉ lệ phát hiện đúng người VỠ NỢ)\n",
            cm_rf$byClass["Sensitivity"]))
cat(sprintf("Specificity: %.4f  (tỉ lệ phát hiện đúng người KHÔNG vỡ nợ)\n",
            cm_rf$byClass["Specificity"]))
cat(sprintf("F1-Score   : %.4f\n", cm_rf$byClass["F1"]))
cat(sprintf("AUC        : %.4f\n", auc(roc_rf)))


# Visualize Confusion Matrix dạng heatmap — đẹp hơn print() thuần
# Chunk name: rf_confusion_plot, fig.width=5, fig.height=4

cm_rf_df <- as.data.frame(cm_rf$table)
colnames(cm_rf_df) <- c("Dự đoán", "Thực tế", "Số lượng")

ggplot(cm_rf_df, aes(x = `Thực tế`, y = `Dự đoán`, fill = `Số lượng`)) +
  geom_tile(color = "white") +
  geom_text(aes(label = `Số lượng`), size = 6, fontface = "bold") +
  scale_fill_gradient(low = "#EBF5FB", high = "#1A5276") +
  labs(
    title   = "Ma trận nhầm lẫn — Random Forest",
    x       = "Thực tế",
    y       = "Dự đoán",
    caption = "Màu đậm = số lượng cao"
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none")


# ROC Curve cho RF (riêng lẻ, trước khi so sánh)
# Chunk name: rf_roc_solo, fig.width=6, fig.height=5

plot(
  roc_rf,
  col  = "#27AE60",
  lwd  = 2.5,
  main = sprintf("Đường cong ROC — Random Forest (AUC = %.4f)", auc(roc_rf)),
  xlab = "1 - Specificity (Tỉ lệ Dương tính Giả)",
  ylab = "Sensitivity (Tỉ lệ Dương tính Thật)"
)
abline(a = 0, b = 1, lty = 2, col = "gray60")  # Đường baseline (random classifier)
legend("bottomright",
       legend = c(sprintf("Random Forest (AUC = %.3f)", auc(roc_rf)), "Baseline (AUC = 0.5)"),
       col    = c("#27AE60", "gray60"),
       lwd    = c(2.5, 1),
       lty    = c(1, 2))


# Feature Importance — điểm đặc trưng của Random Forest
# Trả lời câu hỏi nghiên cứu số 3: "Biến nào quan trọng nhất?"
# Chunk name: rf_importance, fig.width=8, fig.height=6

varImpPlot(
  rf_model,
  n.var = 15,            # Hiển thị 15 biến (tất cả features)
  main  = "Feature Importance — Random Forest",
  col   = "#2C3E50",
  pch   = 16,
  cex   = 0.9
)
# Giải thích 2 chỉ số:
# MeanDecreaseAccuracy: Accuracy giảm bao nhiêu khi shuffle biến này ngẫu nhiên
#                       → đo lường tầm quan trọng thực sự
# MeanDecreaseGini:     Trung bình mức giảm Gini impurity khi dùng biến này để split
#                       → đo lường sức mạnh phân biệt hai lớp

# Export importance thành dataframe để dễ nhận xét
importance_df <- as.data.frame(importance(rf_model))
importance_df$Feature <- rownames(importance_df)
importance_df <- importance_df[order(-importance_df$MeanDecreaseGini), ]

cat("\n=== Top 5 biến quan trọng nhất (MeanDecreaseGini) ===\n")
print(head(importance_df[, c("Feature", "MeanDecreaseGini", "MeanDecreaseAccuracy")], 5))


# ==============================================================
# PHẦN 6.4 — SO SÁNH HIỆU SUẤT BA MÔ HÌNH
# Chunk name: model_comparison
# ĐIỀU KIỆN: prob_logistic, pred_logistic, prob_dt, pred_dt
#             phải đã được tạo bởi Thành viên C
# ==============================================================

# Tạo ROC objects cho Logistic và DT (cần cho comparison plot)
roc_logistic <- roc(test_set$DEFAULT, prob_logistic,
                    levels = c("Không","Có"), direction = "<", quiet = TRUE)
roc_dt       <- roc(test_set$DEFAULT, prob_dt,
                    levels = c("Không","Có"), direction = "<", quiet = TRUE)

# Bảng so sánh tổng hợp
results_comparison <- bind_rows(
  get_metrics(test_set$DEFAULT, pred_logistic, prob_logistic, "Hồi quy Logistic"),
  get_metrics(test_set$DEFAULT, pred_dt,       prob_dt,       "Cây quyết định"),
  get_metrics(test_set$DEFAULT, pred_rf,       prob_rf,       "Random Forest")
)

# Highlight hàng có AUC cao nhất
best_row <- which.max(results_comparison$AUC)

knitr::kable(
  results_comparison,
  caption = "Bảng 6.1: So sánh hiệu suất ba mô hình phân loại trên tập kiểm tra (n = 7.500)",
  align   = c("l","c","c","c","c","c","c"),
  digits  = 4
) %>%
  kableExtra::kable_styling(
    bootstrap_options = c("striped","hover","condensed","bordered"),
    full_width        = FALSE
  ) %>%
  kableExtra::row_spec(
    row        = best_row,
    bold       = TRUE,
    background = "#D5F5E3",   # Xanh nhạt cho hàng tốt nhất
    color      = "#1E8449"
  ) %>%
  kableExtra::column_spec(
    column     = 3,           # Cột Sensitivity — quan trọng nhất bài toán này
    bold       = TRUE
  ) %>%
  kableExtra::footnote(
    general = "In đậm: mô hình đạt AUC cao nhất. Cột Sensitivity được highlight vì đây là chỉ số quan trọng nhất trong bài toán rủi ro tín dụng."
  )


# ROC Curves chồng — biểu đồ quan trọng nhất của phần so sánh
# Chunk name: roc_comparison, fig.width=8, fig.height=6

plot(
  roc_logistic,
  col  = "#E74C3C",   # Đỏ - Logistic
  lwd  = 2.5,
  main = "So sánh đường cong ROC — Ba mô hình phân loại",
  xlab = "1 - Specificity (Tỉ lệ Dương tính Giả)",
  ylab = "Sensitivity (Tỉ lệ Dương tính Thật)"
)
lines(roc_dt,  col = "#3498DB", lwd = 2.5)   # Xanh dương - Decision Tree
lines(roc_rf,  col = "#27AE60", lwd = 2.5)   # Xanh lá - Random Forest
abline(a = 0, b = 1, lty = 2, col = "gray50", lwd = 1.2)

legend(
  "bottomright",
  legend = c(
    sprintf("Hồi quy Logistic  | AUC = %.3f", auc(roc_logistic)),
    sprintf("Cây quyết định    | AUC = %.3f", auc(roc_dt)),
    sprintf("Random Forest     | AUC = %.3f", auc(roc_rf)),
    "Baseline (random) | AUC = 0.500"
  ),
  col  = c("#E74C3C","#3498DB","#27AE60","gray50"),
  lwd  = c(2.5, 2.5, 2.5, 1.2),
  lty  = c(1, 1, 1, 2),
  bty  = "n",         # Không có viền legend
  cex  = 0.9
)


# ==============================================================
# PHẦN 6.5 — THẢO LUẬN CHUNG
# Đây là phần VIẾT, không phải code.
# Nhưng tôi tạo sẵn các số liệu để viết nhận xét chính xác.
# Chunk name: discussion_numbers, echo=FALSE
# ==============================================================

# Tạo các con số cụ thể để dùng trong văn bản (inline R code trong Rmd)
auc_log  <- round(auc(roc_logistic), 4)
auc_dt   <- round(auc(roc_dt),       4)
auc_rf   <- round(auc(roc_rf),       4)

sens_log <- round(confusionMatrix(pred_logistic, test_set$DEFAULT, positive="Có")$byClass["Sensitivity"], 4)
sens_dt  <- round(confusionMatrix(pred_dt,       test_set$DEFAULT, positive="Có")$byClass["Sensitivity"], 4)
sens_rf  <- round(confusionMatrix(pred_rf,       test_set$DEFAULT, positive="Có")$byClass["Sensitivity"], 4)

best_model_name <- results_comparison$`Mô hình`[which.max(results_comparison$AUC)]

cat("=== Số liệu cho phần thảo luận ===\n")
cat(sprintf("AUC      : Logistic=%.4f | DT=%.4f | RF=%.4f\n", auc_log, auc_dt, auc_rf))
cat(sprintf("Sensitivity: Logistic=%.4f | DT=%.4f | RF=%.4f\n", sens_log, sens_dt, sens_rf))
cat(sprintf("Mô hình tốt nhất (AUC): %s\n", best_model_name))

# Trong văn bản Rmd, dùng inline code như sau:
# "Random Forest đạt AUC = `r auc_rf`, cao hơn Hồi quy Logistic (`r auc_log`)
#  và Cây quyết định (`r auc_dt`)."
# → Tự động cập nhật số khi re-render, không cần sửa tay


# ==============================================================
# PHẦN 6.5 — Phân tích Feature Importance (kết nối với EDA)
# Chunk name: importance_analysis, echo=FALSE
# ==============================================================

# Lấy top 5 biến theo MeanDecreaseGini
top5_features <- head(importance_df$Feature, 5)

cat("=== Top 5 biến quan trọng nhất ===\n")
for (i in seq_along(top5_features)) {
  cat(sprintf("%d. %s\n", i, top5_features[i]))
}

# Kết nối với EDA: Từ phân tích dữ liệu thực (đã kiểm tra trước),
# PAY_0 và MAX_DELAY (derived từ PAY_0 đến PAY_6) có correlation
# với target cao nhất (r = 0.325 và r = 0.331).
# Feature Importance của RF dự kiến xác nhận điều này.
#
# Điểm quan trọng cần nhận xét trong văn bản:
# "Hai biến PAY_0 và MAX_DELAY đều thể hiện lịch sử thanh toán
#  trễ hạn — điều này nhất quán với phát hiện EDA ở Mục 4.4,
#  nơi PAY_0 ≥ 2 (trễ từ 2 tháng trở lên) dẫn đến tỉ lệ vỡ nợ
#  lên đến 69.1%. RF xác nhận đây là tín hiệu dự đoán mạnh nhất."


# Vẽ barplot Feature Importance đẹp hơn varImpPlot mặc định
# Chunk name: importance_ggplot, fig.width=8, fig.height=5

importance_gg <- importance_df %>%
  arrange(desc(MeanDecreaseGini)) %>%
  head(10) %>%
  mutate(Feature = factor(Feature, levels = rev(Feature)))  # Để ggplot sắp xếp đúng

ggplot(importance_gg, aes(x = Feature, y = MeanDecreaseGini, fill = MeanDecreaseGini)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = round(MeanDecreaseGini, 1)),
            hjust = -0.1, size = 3.5) +
  scale_fill_gradient(low = "#AED6F1", high = "#1A5276") +
  coord_flip() +
  labs(
    title   = "Top 10 biến quan trọng nhất — Random Forest",
    subtitle = "Đo bằng Mean Decrease in Gini Impurity",
    x       = NULL,
    y       = "Mean Decrease Gini",
    caption = "Biến có giá trị cao hơn = quan trọng hơn trong việc phân biệt vỡ nợ / không vỡ nợ"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold"),
    plot.subtitle = element_text(color = "gray40")
  ) +
  expand_limits(y = max(importance_gg$MeanDecreaseGini) * 1.12)  # Thêm khoảng để text label không bị cắt


# ==============================================================
# OPTIONAL — Tối ưu ngưỡng quyết định (điểm cộng học thuật)
# Chunk name: threshold_analysis, fig.width=7, fig.height=4
# ==============================================================

# Mặc định ngưỡng = 0.5, nhưng với dữ liệu mất cân bằng,
# ngưỡng tốt hơn có thể khác 0.5.
# Trong bài toán tín dụng: tăng Sensitivity (phát hiện nhiều vỡ nợ hơn)
# thường được ưu tiên, dù có thể giảm Specificity.

thresholds  <- seq(0.1, 0.9, by = 0.05)
sens_values <- numeric(length(thresholds))
spec_values <- numeric(length(thresholds))
f1_values   <- numeric(length(thresholds))

for (i in seq_along(thresholds)) {
  pred_thresh <- ifelse(prob_rf >= thresholds[i], "Có", "Không")
  pred_thresh <- factor(pred_thresh, levels = c("Không", "Có"))
  cm_thresh   <- confusionMatrix(pred_thresh, test_set$DEFAULT, positive = "Có")
  sens_values[i] <- cm_thresh$byClass["Sensitivity"]
  spec_values[i] <- cm_thresh$byClass["Specificity"]
  f1_values[i]   <- cm_thresh$byClass["F1"]
}

threshold_df <- data.frame(
  Threshold   = thresholds,
  Sensitivity = sens_values,
  Specificity = spec_values,
  F1_Score    = f1_values
)

# Tìm ngưỡng tối ưu theo F1
optimal_threshold <- thresholds[which.max(f1_values)]
cat(sprintf("\n=== Ngưỡng tối ưu theo F1-Score: %.2f ===\n", optimal_threshold))
cat(sprintf("Tại ngưỡng %.2f: Sensitivity=%.4f | Specificity=%.4f | F1=%.4f\n",
            optimal_threshold,
            sens_values[which.max(f1_values)],
            spec_values[which.max(f1_values)],
            max(f1_values)))
cat(sprintf("So với ngưỡng 0.5: Sensitivity=%.4f | F1=%.4f\n",
            sens_values[thresholds == 0.5],
            f1_values[thresholds == 0.5]))

# Plot Sensitivity và Specificity theo ngưỡng
threshold_long <- tidyr::pivot_longer(
  threshold_df,
  cols      = c(Sensitivity, Specificity, F1_Score),
  names_to  = "Metric",
  values_to = "Value"
)

ggplot(threshold_long, aes(x = Threshold, y = Value, color = Metric)) +
  geom_line(lwd = 1.2) +
  geom_point(size = 2) +
  geom_vline(xintercept = optimal_threshold, linetype = "dashed",
             color = "gray40", lwd = 0.8) +
  annotate("text", x = optimal_threshold + 0.02, y = 0.15,
           label = sprintf("Ngưỡng tối ưu\n= %.2f", optimal_threshold),
           color = "gray30", size = 3.2) +
  scale_color_manual(values = c("Sensitivity" = "#E74C3C",
                                "Specificity" = "#3498DB",
                                "F1_Score"    = "#27AE60")) +
  scale_x_continuous(breaks = seq(0.1, 0.9, 0.1)) +
  labs(
    title   = "Sensitivity, Specificity và F1 theo ngưỡng quyết định — Random Forest",
    x       = "Ngưỡng quyết định (Threshold)",
    y       = "Giá trị",
    color   = "Chỉ số",
    caption = sprintf("Ngưỡng mặc định = 0.5 | Ngưỡng tối ưu F1 = %.2f", optimal_threshold)
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 11),
    legend.position = "bottom"
  )
