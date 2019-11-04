setwd("C:\\Users\\Vijay Rohin\\Documents\\Data_Analysis_Challenge")
install.packages("e1071")

library("e1071")
tfIdfVal <- read.csv(file="tf_idf_features.csv", header=TRUE, sep=",")

train_set <- tfIdfVal[1:106445,]

test_set <- tfIdfVal[106446:133055,]

train_set$topic_id <- as.factor(train_set$topic_id)
set.seed(4100)
train <- sample(nrow(train_set), 0.01*nrow(train_set), replace = FALSE)
TrainSet <- train_set[train,]
ValidSet <- train_set[-train,]

Naive_Bayes_Model=naiveBayes(y=TrainSet[,ncol(TrainSet)], x=TrainSet[,1:(ncol(TrainSet)-2)])

Naive_Bayes_Model

valid_train <- sample(nrow(ValidSet), 0.001*nrow(ValidSet), replace = FALSE)
valid_TrainSet <- ValidSet[valid_train,]
valid_ValidSet <- ValidSet[-valid_train,]
NB_Predictions=predict(Naive_Bayes_Model,valid_TrainSet)

table(NB_Predictions,valid_TrainSet$topic_id)
write.csv(valid_TrainSet$topic_id, file="test_orig.csv")
write.csv(NB_Predictions, file="test_pred.csv")
