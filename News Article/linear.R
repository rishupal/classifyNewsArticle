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
library(MASS)
#ldamodel <- lda(type ~ ., data = Pima.tr, CV = TRUE)
ldamodel <- lda(xg_train$topic_id~., data = xg_train)

lda_pred <- predict(ldamodel, xg_val)
lda_pred
write.csv(xg_val$topic_id,file='test.csv')
write.csv(lda_pred,file='pred.csv')


#tab <- table(Predicted = lda_pred, Actual = xg_train$topic_id)

#1-sum(diag(tab))/sum(tab)
#dtm <- DocumentTermMatrix(xg_train)
library(topicmodels)
#print(typeof(f1))
#f1 <- lapply("29406242_tfidf.csv",readLines)
#dtm1 <- as.DocumentTermMatrix(cbind(xg_train[2,]))
#lda_pred1<- LDA(dtm1,k=23,method="Gibbs")
#dtm1
