## Creating index variable 

# Read the Data
setwd("C:/Users/hp/Desktop/rchh0001/sem2/ADA/Groupassignment")
featuresdata <- read.csv("tf_idf_features.csv" ,header = TRUE)

# Random sampling
#samplesize = 0.01 * nrow(data)
#set.seed(80)
#index = sample( seq_len ( nrow ( data ) ), size = samplesize )

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
str(xg_train)
sapply(xg_train,class)
xg_train$topic_id <- as.character(xg_train$topic_id)
xg_val$topic_id <- as.character(xg_val$topic_id)
n <- names(xg_train)

f <- paste(xg_train,collapse=' + ')
f <- paste('xg_train$topic_id ~',f)

# Convert to formula
f <- as.formula(f)
#f<- as.formula(paste("topic_id~",paste(n[!n %in% "topic_id"], collapse = " + ")))

library("neuralnet")
NN = neuralnet(f , data=xg_train, act.fct="logistic", lifesign="minimal", linear.output = F )
pred_data = compute(NN,xg_train)
pred_data
predict_testNN = (pred_data$net.result)
RMSE.NN = (sum((xg_train$topic_id - predict_testNN )^2) / nrow(xg_train)) ^ 0.5
RMSE.NN
