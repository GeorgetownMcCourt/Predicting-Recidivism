
#Creating dataframe of just potential model varaibles and then dropping NAs
model.var <- c("CH_CRIMHIST_COLLAPSED", "OFFENSE_VIOLENT", "OFFENSE_DRUG","OFFENSE_PROPERTY","SES_PHYSABUSED_EVER","CS_SENTENCEMTH", 
                 "SES_PARENTS_INCARCERATED", "SES_FAMILY_INCARCERATED", "SES_HASCHILDREN", "AGE_CAT", 
                 "SES_SEXABUSED_EVER", "DRUG_ANYREG", "DRUG_ANYTME", "black.nh", "hispanic", "asian", "state", "EDUCATION","SES_FATHER_INCARCERATED",
               "DRUG_COCRKTME", "DRUG_HROPTME", "DRUG_METHATME", "LIFE_SENTENCE", "GENDER", "TYPEOFFENSE", "DRUG_MARIJTME",
               "CH_PRIORARREST_CAT", "SES_LIVE_CHILD_ARREST", "DRUG_ABUSE_ONLY", "DRUG_TRT")

model.data <- full.numeric[model.var]

model.data <- model.data[complete.cases(model.data),]

###Setting up Train/Test/Validate###
set.seed(42)
rand <- runif(nrow(model.data))

trainset <- model.data[rand >= 0.3,]
testset <- model.data[rand >= 0.15 & rand < 0.3,]
valset <- model.data[rand < 0.15,]

#Set up Mean-F1#
meanf1 <- function(actual, predicted){
  
  classes <- unique(actual)
  results <- data.frame()
  for(k in classes){
    results <- rbind(results, 
                     data.frame(class.name = k,
                                weight = sum(actual == k)/length(actual),
                                precision = sum(predicted == k & actual == k)/sum(predicted == k), 
                                recall = sum(predicted == k & actual == k)/sum(actual == k)))
  }
  results$score <- results$weight * 2 * (results$precision * results$recall) / (results$precision + results$recall) 
  return(sum(results$score))
}

###First Predictive Model###

glm.fit <- glm(CH_CRIMHIST_COLLAPSED ~ OFFENSE_VIOLENT + OFFENSE_DRUG + OFFENSE_PROPERTY + CS_SENTENCEMTH +  
                 SES_PARENTS_INCARCERATED + SES_FAMILY_INCARCERATED + SES_HASCHILDREN + AGE_CAT + 
                 SES_SEXABUSED_EVER + DRUG_ANYREG + state + GENDER + DRUG_COCRKTME + DRUG_HROPTME + DRUG_ANYTME + DRUG_METHATME +
                 CH_PRIORARREST_CAT + TYPEOFFENSE + DRUG_TRT + EDUCATION, 
               data = trainset,
               family = binomial())

summary(glm.fit)

#Predict Train and Validate#
predict.glm.train <- predict(glm.fit, trainset, type = "response")
predict.glm.val <- predict(glm.fit, valset, type = "response")

##Mean F1 Calculations for cutoff of 0.5##

#Applying predicted labels
train.recid <- predict.glm.train > 0.5
train.recid[train.recid == TRUE] <- "Recidivist"
train.recid[train.recid == FALSE] <- "First Timer"

#Applying labels to trainset
train.real <- trainset$CH_CRIMHIST_COLLAPSED
train.real[train.real == 1] <- "Recidivist"
train.real[train.real == 0]  <- "First Timer"

#Calculating Mean-F1 for training set
meanf1(train.real, train.recid) #.801

#Checking confusion matrix#
table(trainset$CH_CRIMHIST_COLLAPSED, train.recid) #High sensitivity, but low specificity. Probably not what we want. Adjusting cutoff

#Applying predicted labels to predicted set
val.recid <- predict.glm.val > 0.5
val.recid[val.recid == TRUE] <- "Recidivist"
val.recid[val.recid == FALSE] <- "First Timer"

#Applying labels to our original set
val.real <- valset$CH_CRIMHIST_COLLAPSED
val.real[val.real== 1] <- "Recidivist"
val.real[val.real == 0] <- "First Timer"


meanf1(val.real, val.recid) # ~.794

#Checking confusion matrix#
table(val.recid, val.real) #High sensitivity, but low specificity. Probably not what we want. Adjusting cutoff


##Mean F1 calculations for cutoff of 0.60##

#Applying predicted labels
train.recid <- predict.glm.train > 0.60
train.recid[train.recid == TRUE] <- "Recidivist"
train.recid[train.recid == FALSE] <- "First Timer"

# Mean F1
meanf1(train.real, train.recid) #.796
#Checking confusion matrix#
table(train.real, train.recid) #Pretty close to a good balance

#Applying predicted labels to validation set
val.recid <- predict.glm.val > 0.60
val.recid[val.recid == TRUE] <- "Recidivist"
val.recid[val.recid == FALSE] <- "First Timer"

# Mean F1
meanf1(val.real, val.recid) #.794

#Checking confusion matrix#
table(val.real, val.recid) #Still close to a good balance

