# Packages/Libraries to be included for modelling
#install.packages("devtools")
require(devtools)
library(xgboost)
#library(randomForest)

# Importing/Loading data containing tfidf vectors of documents along with their terms (tokens)
tfIdfVal <- read.csv(file="tf_idf_features.csv", header=TRUE, sep=",")

# Segregating train and test data seperately
train_set <- tfIdfVal[1:106445,]
test_set <- tfIdfVal[106446:133055,]

# Creating a duplicate copy of the original train dataset
filelist <- train_set

# Since class id's in xgboost starts with zero, we have subracted 1 from the topic ids (numeric initially)
filelist$topic_id - 1

# Numeric topic_id gets converted into factors
filelist$topic_id <- as.factor(filelist$topic_id)

# Selecting records randomly for valid dataset construction
set.seed(4100)
train <- sample(nrow(filelist), 0.8*nrow(filelist), replace = FALSE)

# Seperating training and validation dataset
TrainSet <- filelist[train,]
ValidSet <- filelist[-train,]


start.time <- Sys.time() # Noting down the start time of the process (modelling)
# XgBoost function to perform modelling with trainset as matrix with corresponding topic_ids as labels, 100 rounds and 24 classes (num of labels + 1)
model_xgboost <- xgboost(booster="gbtree", data = as.matrix(TrainSet[, 1:930]), label = TrainSet[,ncol(TrainSet)], nrounds=100, objective="multi:softmax", num_class=24)
end.time <- Sys.time()  # Noting down the end time of the process (modelling)
time.taken <- end.time - start.time # Evaluating time difference between start and end time
time.taken # Prining time difference in the console

# Saving the xgboost model for backup
xgb.save(model_xgboost, "xgboost_model")
# Loading the xgboost model
model_xgboost <- xgb.load("xgboost.model")
#load("rf_data.RData")

# Predicting the classes/lables for validation dataset
pred <- predict(model_xgboost, as.matrix(ValidSet[, 1:966]))
length(pred)  # Length of the predicted values

# Assigning topic_id to temp variable
test_doc_list <- ValidSet$topic_id
pred_list <- list(pred) # Converting predicted values as list 
test_doc_list <- list(test_doc_list) # Converting doc_id as list
test_df_df <-do.call(rbind, Map(data.frame, A=test_doc_list, B=pred_list)) # Combining both predicted values and doc_ids as a data frame (df)
test_df_df$B <- paste("C", test_df_df$B, sep="") # Appedning "C" to all the predicted class values
write.table(test_df_df, file="testing_labels_pred_pre_final.txt", sep=" ", row.names = FALSE, quote = FALSE, col.names = FALSE) # Writing the data-frame as text file with space seperation


write.csv(ValidSet$topic_id, file="test_orig.csv") # Writing Validation dataset topic_id individually (seperately)
write.csv(pred, file="test_pred.csv") # Writing predicted topic_id individually (seperately)


pred_test_final <- predict(model_xgboost, as.matrix(test_set[,1:966])) # Predicting the classes/lables for validation dataset
length(pred_test_final) # Length of the predicted values
test_doc_list <- test_set$doc_id # Assigning test dataset doc_id to a temp variable

pred_list <- list(pred_test_final) # Converting predicted values as list
test_doc_list <- list(test_doc_list) # Converting doc_id as list
test_df_df <-do.call(rbind, Map(data.frame, A=test_doc_list, B=pred_list)) # Combining both predicted values and doc_ids as a data frame (df)
test_df_df$B <- paste("C", test_df_df$B, sep="") # Appedning "C" to all the predicted class values
write.table(test_df_df, file="testing_labels_pred.txt", sep=" ", row.names = FALSE, quote = FALSE, col.names = FALSE) # Writing the data-frame as text file with space seperation
