#install.packages("VGAM")
library(VGAM)
library(class)
library("e1071")

tfIdfVal <- read.csv(file="tf_idf_features.csv", header=TRUE, sep=",")

train_set <- tfIdfVal[1:106445,]
test_set <- tfIdfVal[106446:133055,]
set.seed(4100)
train_rows_set <- sample(nrow(train_set), 0.1*nrow(train_set), replace = FALSE)
train_set_sample <- train_set[train_rows_set,]
valid_set_sample <- train_set[-train_rows_set,]
valid_row_set <- sample(nrow(valid_set_sample), 0.02*nrow(valid_set_sample), replace = FALSE)
valid_set_sample_final <- valid_set_sample[valid_row_set,]

model_svm  = svm(x=train_set_sample[,1:(ncol(train_set_sample)-2)], y=train_set_sample[,ncol(train_set_sample)])
svm_pred=predict(model_svm,valid_set_sample_final[,1:(ncol(valid_set_sample_final)-2)])
write.csv(valid_set_sample_final$topic_id, file="test_orig.csv")
write.csv(svm_pred, file="test_pred.csv")