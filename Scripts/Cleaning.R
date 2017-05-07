
setwd("C:/Users/Seth/Documents") # adjust individually

#install.packages("memisc") 
library(memisc)

#### 1) DATA EXTRACTION ####

## Extract .rda files for Federal and State Analysis data from Github #

# This function assigns the loaded data frame the desired name directly

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

# Federal Analysis Data
url <- "https://github.com/GeorgetownMcCourt/Predicting-Recidivism/raw/master/Data/FederalAnalysisR.rda"
temp = tempfile() #Create temp file
download.file(url, temp) #download the URL direct to the temp file
fed.an <- loadRData(temp)


# State Analysis Data
url <- "https://github.com/GeorgetownMcCourt/Predicting-Recidivism/raw/master/Data/StateAnalysisR.rda"
temp = tempfile() #Create temp file
download.file(url, temp) ##download the URL direct to the temp file
state.an <- loadRData(temp)

#Creates a dummy for State T/F before combining fed.an and state.an
state.an$state <- TRUE
fed.an$state <- FALSE

full.an <- rbind(fed.an,state.an)

# rename first column (id's) and change to character
names(full.an)[1] <- "ID"
full.an$ID <- as.character(full.an$ID)

#### 2) DATA CLEANING ####

# replicate dataset in order to check back with orignial dataset if all changes made are true to data
full.numeric <- full.an

### Generate recidivism variable - running this first to ensure no other recoding interferes with it

full.numeric$CH_CRIMHIST_COLLAPSED <- full.an$CH_CRIMHIST_COLLAPSED # reassign original variable

full.numeric$CH_CRIMHIST_COLLAPSED <- as.character(full.numeric$CH_CRIMHIST_COLLAPSED) #convert to character

full.numeric$CH_CRIMHIST_COLLAPSED <- recode(full.numeric$CH_CRIMHIST_COLLAPSED, #recode
                                             0 <- "(0000001) First timers",
                                             1 <- c("(0000002) Recidivist, current or past violent offense", 
                                                    "(0000003) Recidivist, no current or prior violent offense"),
                                             otherwise = NA)
full.numeric$CH_CRIMHIST_COLLAPSED <- as.numeric(as.character(full.numeric$CH_CRIMHIST_COLLAPSED))


# create list with factor levels to get idea of categorical values
levels.list <- vector("list", length = ncol(full.numeric))

for (i in 2:ncol(full.numeric)) {
  if (is.factor(full.numeric[,i]) == T) {
    levels.list[[i]] <- levels(full.numeric[,i]) # extract factor levels
  }
}


## Start with Factors with 3 Levels: Some Form of Yes, No, Missing

# change factor labels for harmonization
for (i in 2:ncol(full.numeric)) {
  if (is.factor(full.numeric[,i]) == T & length(levels(full.numeric[,i])) == 3) {
    
    # remove punctuation, spaces, and alphabetic expressions
    levels(full.numeric[,i]) <- gsub("[[:punct:]]", "", levels(full.numeric[,i]))
    levels(full.numeric[,i]) <- gsub("[[:space:]]", "", levels(full.numeric[,i]))
    levels(full.numeric[,i]) <- gsub("[[:alpha:]]", "", levels(full.numeric[,i]))
    # now the factor label should be numeric only
    
  }
}

# convert into character vector and recode
for (i in 2:ncol(full.numeric)) {
  if (is.factor(full.numeric[,i]) == T & length(levels(full.numeric[,i])) == 3) {
    
    full.numeric[,i] <- as.character(full.numeric[,i])
    
    full.numeric[,i] <- recode(full.numeric[,i],
                               1 <- "0000001",
                               0 <- c("0000000", "0000002"),
                               otherwise = NA)
    
    full.numeric[,i] <- as.numeric(as.character(full.numeric[,i]))
    
  }
}


## Factors with 4 Levels: Some Form of Yes, No, Missing
for (i in 2:ncol(full.numeric)) {
  if (is.factor(full.numeric[,i]) == T & length(levels(full.numeric[,i])) == 4) {
    
    # remove punctuation, spaces, and alphabetic expressions
    levels(full.numeric[,i]) <- gsub("[[:punct:]]", "", levels(full.numeric[,i]))
    levels(full.numeric[,i]) <- gsub("[[:space:]]", "", levels(full.numeric[,i]))
    levels(full.numeric[,i]) <- gsub("[[:alpha:]]", "", levels(full.numeric[,i]))
    # now the factor label should be numeric only
    
  }
}

# convert into character vector and recode
for (i in 2:ncol(full.numeric)) {
  if (is.factor(full.numeric[,i]) == T & length(levels(full.numeric[,i])) == 4) {
    
    full.numeric[,i] <- as.character(full.numeric[,i])
    
    full.numeric[,i] <- recode(full.numeric[,i],
                               1 <- "0000001",
                               0 <- c("0000002", "0000004"),
                               otherwise = NA)
    
    full.numeric[,i] <- as.numeric(as.character(full.numeric[,i]))
    
  }
}

##Recoding Gender - this is the only two level variable that is not yes/no, so we run this first so it doesn't get overwritten by the 2 level recode
full.numeric$GENDER <- as.character(full.numeric$GENDER)

full.numeric$GENDER <- recode(full.numeric$GENDER,
                              0 <- "(1) Male",
                              1 <- c("(2) Female"),
                              otherwise = "copy")

full.numeric$GENDER <- as.numeric(full.numeric$GENDER)

#Convert 1 = Yes 2 = No w/ no missing
for (i in 2:ncol(full.numeric)) {
  if (is.factor(full.numeric[,i]) == T & length(levels(full.numeric[,i])) == 2) {
    
    full.numeric[,i] <- as.character(full.numeric[,i])
    
    full.numeric[,i] <- recode(full.numeric[,i],
                               1 <- "(1) Yes",
                               0 <- c("(2) No"),
                               otherwise = NA)
    
    full.numeric[,i] <- as.numeric(as.character(full.numeric[,i]))
    
  }
}

# Create Race Dummies

full.numeric$hispanic <- NA
full.numeric$hispanic <- ifelse(full.numeric$RACE == "(0000003) Hispanic", full.numeric$hispanic <- 1,
                                ifelse(full.numeric$RACE == "(9999999) Missing", full.numeric$hispanic <- NA, 0))

full.numeric$black.nh <- NA
full.numeric$black.nh <- ifelse(full.numeric$RACE == "(0000002) Black non-hispanic", full.numeric$black.nh <- 1,
                                ifelse(full.numeric$RACE == "(9999999) Missing", full.numeric$black.nh <- NA, 0))

full.numeric$asian <- NA
full.numeric$asian <- ifelse(full.numeric$RACE == "(0000005) Asian, pacific islander, native hawaiian non-hispanic", 
                             full.numeric$asian <- 1,
                             ifelse(full.numeric$RACE == "(9999999) Missing", full.numeric$asian <- NA, 0))


## Recode CS_SENTENCEMTH (Length of Sentence in Month)

full.numeric$CS_SENTENCEMTH[full.numeric$CS_SENTENCEMTH > 10000] <- NA ## convert all Missings

full.numeric$CS_SENTENCEMTH <- as.numeric(full.numeric$CS_SENTENCEMTH) ## NB: Length of 10,000 == Life or Death Sentence

full.numeric$LIFE_SENTENCE <- ifelse(full.numeric$CS_SENTENCEMTH == 10000, 1, 0) ## Creates variable for life sentence

full.numeric$CS_SENTENCEMTH[full.numeric$CS_SENTENCEMTH == 10000] <- NA ## Converts life sentence in months to NA

##Recode SES_PARENTS_INCARCERATED, SES_HASCHILDREN, SES_FAMILY_INCARCERATED, DRUG_TRT, SES_INCOMEILLEGALMTH, SES_INCOMEWELFAREMTH

vars <- c("SES_PARENTS_INCARCERATED", "SES_HASCHILDREN", "SES_FAMILY_INCARCERATED", "DRUG_TRT", "SES_INCOMEILLEGALMTH", "SES_INCOMEWELFAREMTH")

# Removes punctuation, spaces, and alphabetic expressions

for (i in vars) {
  levels(full.numeric[,i]) <- gsub("[[:punct:]]", "", levels(full.numeric[,i]))
  levels(full.numeric[,i]) <- gsub("[[:space:]]", "", levels(full.numeric[,i]))
  levels(full.numeric[,i]) <- gsub("[[:alpha:]]", "", levels(full.numeric[,i]))
  # now the factor label should be numeric only
}

# Converts into a character vector and recodes

for (i in vars) {
  full.numeric[,i] <- as.character(full.numeric[,i])
  
  full.numeric[,i] <- recode(full.numeric[,i],
                             1 <- "0000001",
                             0 <- c("0000002"),
                             otherwise = NA)
  full.numeric[,i] <- as.numeric(as.character(full.numeric[,i]))
}


## Removing Missing + non-US education categories from Education 
levels(full.numeric$EDUCATION) <- gsub("[[:punct:]]", "", levels(full.numeric$EDUCATION))
levels(full.numeric$EDUCATION) <- gsub("[[:space:]]", "", levels(full.numeric$EDUCATION))
levels(full.numeric$EDUCATION) <- gsub("[[:alpha:]]", "", levels(full.numeric$EDUCATION))

full.numeric$EDUCATION <- as.character(full.numeric$EDUCATION)

full.numeric$EDUCATION <- recode(full.numeric$EDUCATION,
                                 NA <- c("0000019","9999997","9999998","9999999"),
                                 otherwise = "copy")

full.numeric$EDUCATION <- as.factor(full.numeric$EDUCATION)

## Removing Missing Values from SES_INCOMEMTH
full.numeric$SES_INCOMEMTH <- as.character(full.numeric$SES_INCOMEMTH)

full.numeric$SES_INCOMEMTH <- recode(full.numeric$SES_INCOMEMTH,
                                     NA <- c("(9999997) Don't know","(9999998) Refused","(9999999) Missing"),
                                     otherwise = "copy")

full.numeric$SES_INCOMEMTH <- as.factor(full.numeric$SES_INCOMEMTH)

##Recoding Type of Offense
## Removing Missing + non-US education categories from Education 
full.numeric$TYPEOFFENSE <- as.character(full.numeric$TYPEOFFENSE)

full.numeric$TYPEOFFENSE <- recode(full.numeric$TYPEOFFENSE,
                                   NA <- c("(9999997) DK/refused","(9999998) Missing", "(9999999) Blank"),
                                   otherwise = "copy")

full.numeric$TYPEOFFENSE <- as.factor(full.numeric$TYPEOFFENSE)

#Removing missing from Prior Arrests and Prior Incarcerations
var <- c("CH_PRIORARREST_CAT", "CH_NUMCAR")

for (i in var) {
  full.numeric[,i] <- recode(full.numeric[,i],
                             NA <- c(9999997, 9999998, 9999999),
                             otherwise ="copy")
}
