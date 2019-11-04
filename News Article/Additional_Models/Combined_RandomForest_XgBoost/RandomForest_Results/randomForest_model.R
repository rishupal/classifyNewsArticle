# Packages/Libraries to be included for modelling
#install.packages("devtools")
require(devtools)
#library(xgboost)
library(randomForest)

# Importing/Loading data containing tfidf vectors of documents along with their terms (tokens)
tfIdfVal <- read.csv(file="tf_idf_features.csv", header=TRUE, sep=",")

# Segregating train and test data seperately
train_set <- tfIdfVal[1:106445,]
test_set <- tfIdfVal[106446:133055,]

# Creating a duplicate copy of the original train dataset
filelist <- train_set

# Numeric topic_id gets converted into factors
filelist$topic_id <- as.factor(filelist$topic_id)

start.time <- Sys.time() # Noting down the start time of the process (modelling)
# Random Forest function to perform modelling with trainset with corresponding topic_ids as labels, trace print for 10 trees upto 500 trees (priority)
model = randomForest(y = filelist[,ncol(filelist)], x = filelist[, 1:(ncol(filelist)-2)], do.trace=10, ntree = 500, important=TRUE)
end.time <- Sys.time()  # Noting down the end time of the process (modelling)
time.taken <- end.time - start.time # Evaluating time difference between start and end time
time.taken # Prining time difference in the console

# Saving the random forest model for backup
save(model, file = "rf_data.RData")
# Loading the xgboost model
load("rf_data.RData")

pred_test_final <- predict(model, test_set[,1:966]) # Predicting the classes/lables for validation dataset
length(pred_test_final) # Length of the predicted values
test_doc_list <- test_set$doc_id # Assigning test dataset doc_id to a temp variable

pred_list <- list(pred_test_final) # Converting predicted values as list
test_doc_list <- list(test_doc_list) # Converting doc_id as list
test_df_df <-do.call(rbind, Map(data.frame, A=test_doc_list, B=pred_list)) # Combining both predicted values and doc_ids as a data frame (df)
test_df_df$B <- paste("C", test_df_df$B, sep="") # Appedning "C" to all the predicted class values
write.table(test_df_df, file="testing_labels_pred.txt", sep=" ", row.names = FALSE, quote = FALSE, col.names = FALSE) # Writing the data-frame as text file with space seperation
