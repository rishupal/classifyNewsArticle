# Packages/Libraries to be included for modelling
# e1071 - for SVM function
library(e1071)

# Importing/Loading data containing tfidf vectors of documents along with their terms (tokens)
tfIdfVal <- read.csv(file="tf_idf_features.csv", header=TRUE, sep=",")

# Segregating train and test data seperately
train_set <- tfIdfVal[1:106445,]
test_set <- tfIdfVal[106446:133055,]

# Creating a duplicate copy of the original train dataset
filelist <- train_set

# Numeric topic_id gets converted into factors
filelist$topic_id <- as.factor(filelist$topic_id)

# SVM function to perform modelling with trainset with corresponding topic_ids as labels
#model_svm <- svm(filelist[,1:(ncol(filelist)-2)], filelist[,ncol(filelist)])

# Saving the svm model for backup
#save(model_svm, file="svm_model.RData")
# Loading the xgboost model
load("svm_model.RData")


pred_test_final <- predict(model_svm, test_set[,1:930]) # Predicting the classes/lables for validation dataset
length(pred_test_final) # Length of the predicted values
test_doc_list <- test_set$doc_id # Assigning test dataset doc_id to a temp variable

pred_list <- list(pred_test_final) # Converting predicted values as list
test_doc_list <- list(test_doc_list) # Converting doc_id as list
test_df_df <-do.call(rbind, Map(data.frame, A=test_doc_list, B=pred_list)) # Combining both predicted values and doc_ids as a data frame (df)
test_df_df$B <- paste("C", test_df_df$B, sep="") # Appedning "C" to all the predicted class values
write.table(test_df_df, file="testing_labels_pred.txt", sep=" ", row.names = FALSE, quote = FALSE, col.names = FALSE) # Writing the data-frame as text file with space seperation
