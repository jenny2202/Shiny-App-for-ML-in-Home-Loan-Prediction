
### Choosing the best performed model from a ranges of ML models
# Loading data

setwd("C:/Users/mlcl.local/Desktop/Self-Studied-R-and-Python/Shiny-on-home-loan")

library(tidyverse)
library(magrittr)
hmeq <- read.csv("http://www.creditriskanalytics.net/uploads/1/9/5/1/19511601/hmeq.csv", sep = ",", header = TRUE)
head(hmeq)


## 1
replace_na_mean <- function(x){
  mean <- mean(x, na.rm = TRUE)
  x[is.na(x)] <- mean
  return(x)
}



## 2
name_job <- function(x){
  x %<>% as.character()
  ELSE <- TRUE
  job_name <- c("Mgr", "Office", "Other", "ProfExe", "Sales", "Self")
  case_when(!x %in% job_name ~ "Other", 
            ELSE ~ x) 
  
} 



## 3
name_reason <- function(x){
  ELSE <- TRUE
  x %<>% as.character()
  case_when(!x  %in%  c("DebtCon", "HomeImp") ~ "Unknown",
            ELSE ~ x)
  
}



## 4
label_rename <- function(x){
  case_when(x==1 ~ "BAD",
            x==0 ~ "GOOD")
}




library(randomForest)

## Final data for slitting 
df <- hmeq %>% 
  mutate_if(is.numeric, replace_na_mean) %>% 
  mutate_at("REASON", name_reason) %>% 
  mutate_at("JOB", name_job) %>% 
  mutate(BAD = label_rename(BAD)) %>% 
  mutate_if(is.character, as.factor)

head(df)


library(caret)
set.seed(1)
id <- createDataPartition(y = df$BAD, p = 0.5, list = FALSE)
train <- df[id,]
test <- df[id,]




# Set up parameterization and cross-validation:
set.seed(1)
trainControl <- trainControl(method = "repeatedcv",
                             number = 5,
                             repeats = 5,
                             classProbs = TRUE,
                             allowParallel = TRUE,
                             summaryFunction = multiClassSummary) 


# Set up parallel computing mode

library(doParallel)
n_cores <- detectCores()

registerDoParallel(cores = n_cores - 1)
# Write the average calculation functions for 
# the classification criteria of the model 
# with the selection of 1000 observation patterns from testing data 100 times.





set.seed(1)
my_rf <- train(BAD ~.,
               data = train,
               method = "rf",
               metric = "AUC", 
               trControl = trainControl,
               tuneLength = 5
               
)


# Save the model

save(my_rf , file = 'RandomForestTuned.rda')


