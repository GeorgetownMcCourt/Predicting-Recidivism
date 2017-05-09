# Predicting Recidivism in the U.S. Prison Population

## Overview/Synopsis
The goal of this project is to analyze correlations between recidivism and socio-economic characteristics, mental health, family background, drug use, type of prior offenses and convictions, etc. to predict the probability of recidivism among prisoners. We intend to make predictions regarding important risk factors and to draw policy conclusions as to how the risk of recidivism can be lowered for different types of (former) prisoners. For instance, identifying certain mental health patterns or drug abuse behaviors that significantly increase the risk of recidivism would help in setting priorities in health care and/or social work care for released prisoners.

## Use
To predict recidvism, we take several approaches. Our first approach uses logistic regression, which allows us to assess how individual features affect recidivism. This enables actionable policy recommmendations to assist released prisoners and prevent recidivism. For this approach we partition our dataset into 70/15/15 train, validate, and test sets. 

Our other approaches are k-Nearest Neighbors, a Decision Tree, and a Random Forest. These approaches limit some of the learnings about how individual factors affect reidvism. Our intent for these approaches is to develop as accurate of a prediction of recidivism as possible and compare it to the accuracy of our logistic approach. We use k-folds cross validation (k=5) for these approaches. 

## Data Used
The data used in this project is retrieved from the 2004 Survey of Inmates in State Correctional Facilities (SISCF) and the 2004 Survey of Inmates in Federal Correctional Facilities (SIFCF). These surveys, collectively referred to as the 2004 Survey of Inmates in State and Federal Correctional Facilities (SISFCF), provide nationally representative data on inmates held in state prisons and federal prisons for the year 2004. Collected through personal interviews conducted from October 2003 through May 2004, the data captures information about prisoners’ current offense and sentence, criminal history, family background, socio-economic characteristics, prior drug and alcohol use and treatment programs, gun possession and use, as well as prison activities, programs, and services. 

This data is maintained by the National Archive of Criminal Justice Data and has been pre-processed to anonymize any potentially identifiable information. 

The data is split into 4 datasets: full federal data, full state data, federal analysis data, and state analysis data. The full federal and state datasets contain all data collected by the survey as it was entered by the survey enumerators. The analysis datasets contain a selection of variables partially prepared for analysis. 

## Usage
The .Rscript file "Cleaning" constructs our recidivism target feature, recodes many of the variables within the federal and state analysis datasets for easier interpretation, and recodes observations intitially coded as missing/unavaiable in the survey as NA. To run this script change the working directory to your preferred working directory, and install the package "memisc". This package is used in this script to simplify recoding of variables from survey data. 

The. Rscript file GLM Prediction Model partitions the data into 70/15/15 train, validate, and test datasets and uses binomial GLM to predict recidivism. Mean F1 is used to measure error in our predictions. Multiple cutoffs are tested and confusion matrixes are generated to examine the tradeoff between sensitivity and specificity in our model.

The .Rscript files "1-KNN-Predictions", "2-DT-Predictions", and "3-RF-Predictions" sets up k-folds cross validation and runs several models each for our k-Nearest Neighbors, Decision Tree, and Random Forest approaches respectively. These scripts are intended to be run in order. 

Finally, our RMD file "Predicting_Recidivism" is a written report of our findings and contains the code for our most optimal models. This file uses the "stargazer" package and the kable function within the "knitr" package to generate useful tables. The file "Predicting_Recidivism.pdf" is a knitted pdf of our final report. 

## Progress Log
- Project data identified and downloaded 3/28/17
- Project proposal submitted 3/29/17
- Project github repo initialized 4/11/17
- Data and codebook uploaded to repo 4/11/17
- Upload .csv and .Rda versions of datasets for easier use 4/21/17
- Upload .Rscript file that sets up data and runs theoretical models 4/24/17
- Upload .Rscript file that uses GLM to predict recidvisim and measures accuracy with Mean F1 5/5/17
- Upload .Rscript files that test decision trees, KNN, and random forest 5/7/17
- Upload final .rmd and .pdf 5/8/17

## Credits
Credit to Viola Hilbert, Shashank Shekhr Rai, and Seth Taylor.

## License
Due to the potentially sensitive ethical nature of this work, we maintain exclusive copyright within the Github Terms of Service. 
