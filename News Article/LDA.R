setwd("C:/Users/hp/Desktop/rchh0001/sem2/ADA/Groupassignment")
featuresdata <- read.csv("29406242_tfidf.csv" ,header = TRUE)

library(tm)
library(caTools)
sp <- sample.split(Y = featuresdata$topic_id,SplitRatio = 0.01) # SAMPLE SIZE SELECTION
train_split <- subset(featuresdata,sp ==TRUE)
remaining_split <- subset(featuresdata,sp ==FALSE)

# split data into train & validation set
sp2 <- sample.split(Y = train_split$topic_id,SplitRatio = 0.7) #choose validation split ratio
xg_train <- subset(train_split,sp2 ==TRUE)
xg_val <- subset(train_split,sp2 ==FALSE)

xg_train$doc_id <- NULL
library(RTextTools)
matrix <- create_matrix(cbind(xg_train[2,]), language="english", removeNumbers=TRUE, stemWords=TRUE, weighting=weightTf)
