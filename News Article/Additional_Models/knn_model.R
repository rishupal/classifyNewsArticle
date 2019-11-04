library(VGAM)
library(class)


tfIdfVal <- read.csv(file="tf_idf_features.csv", header=TRUE, sep=",")


train_set <- tfIdfVal[1:106445,]
test_set <- tfIdfVal[106446:133055,]
set.seed(100)
train_rows_set <- sample(nrow(train_set), 0.2*nrow(train_set), replace = FALSE)
train_set_sample <- train_set[train_rows_set,]
valid_set_sample <- train_set[-train_rows_set,]
valid_row_set <- sample(nrow(valid_set_sample), 0.1*nrow(valid_set_sample), replace = FALSE)
valid_set_sample_final <- valid_set_sample[valid_row_set,]

model_knn = knn(train_set_sample[,1:(ncol(train_set_sample)-2)],valid_set_sample_final[,1:(ncol(valid_set_sample_final)-2)], train_set_sample[,ncol(train_set_sample)], k=100)

write.csv(valid_set_sample_final$topic_id, file="test_orig.csv")
write.csv(model_knn, file="test_pred.csv")
