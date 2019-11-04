setwd("C:/Users/hp/Desktop/rchh0001/sem2/ADA/Groupassignment")
featuresdata <- read.csv("29406242_tfidf.csv" ,header = TRUE)
#featuresdata
table(featuresdata$topic_id)
# split training & test data 
library(caTools)
sp <- sample.split(Y = featuresdata$topic_id,SplitRatio = 0.01) # SAMPLE SIZE SELECTION
train_split <- subset(featuresdata,sp ==TRUE)
remaining_split <- subset(featuresdata,sp ==FALSE)

# split data into train & validation set
sp2 <- sample.split(Y = train_split$topic_id,SplitRatio = 0.7) #choose validation split ratio
xg_train <- subset(train_split,sp2 ==TRUE)
xg_val <- subset(train_split,sp2 ==FALSE)

# doc_id for train & validation set
# xg_train_doc_id <- xg_train$doc_id
# xg_val_doc_id <- xg_val$doc_id


#xg_train$topic_id <- as.factor(xg_train$topic_id)
#xg_train$doc_id <- as.character(xg_train$doc_id)

#remove doc_id column

xg_train$doc_id <- NULL

#xg_val_target <- as.numeric(xg_val$topic_id)
library(e1071)
model <- svm(xg_train$topic_id~., data = xg_train)

svm_pred <- predict(model, xg_train)

tab <- table(Predicted = svm_pred, Actual = xg_train$topic_id)

1-sum(diag(tab))/sum(tab)
