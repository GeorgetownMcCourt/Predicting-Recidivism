# Predicting Recidivism in the U.S. Prison Population

## Overview/Synopsis
The goal of this project is to analyze correlations between recidivism and socio-economic characteristics, mental health, family background, drug use, type of prior offenses and convictions, etc. to predict the probability of recidivism among prisoners. We intend to make predictions regarding important risk factors and to draw policy conclusions as to how the risk of recidivism can be lowered for different types of (former) prisoners. For instance, identifying certain mental health patterns or drug abuse behaviors that significantly increase the risk of recidivism would help in setting priorities in health care and/or social work care for released prisoners.

## Use
To predict recidvism, we take two approaches. Our first approach uses logistic regression, which allows us to assess how individual features affect recidivism. This enables actionable policy recommmendations to assist released prisoners and prevent recidivism.

Our second planned approach is a random forest. The use of a random forest neccessarily restricts learning about individual features. Our intent for this approach is to develop as accurate of a prediction of recidivism as possible and compare it to the accuracy of our logistic approach. 

We intend to use k-fold cross-validation for partitioning and validation of our predictions. 

## Data Used
The data used in this project is retrieved from the 2004 Survey of Inmates in State Correctional Facilities (SISCF) and the 2004 Survey of Inmates in Federal Correctional Facilities (SIFCF). These surveys, collectively referred to as the 2004 Survey of Inmates in State and Federal Correctional Facilities (SISFCF), provide nationally representative data on inmates held in state prisons and federal prisons for the year 2004. Collected through personal interviews conducted from October 2003 through May 2004, the data captures information about prisoners’ current offense and sentence, criminal history, family background, socio-economic characteristics, prior drug and alcohol use and treatment programs, gun possession and use, as well as prison activities, programs, and services. 

This data is maintained by the National Archive of Criminal Justice Data and has been pre-processed to anonymize any potentially identifiable information. 

The data is split into 4 datasets: full federal data, full state data, federal analysis data, and state analysis data. The full federal and state datasets contain all data collected by the survey as it was entered by the survey enumerators. The analysis datasets contain a selection of variables partially prepared for analysis 

## Usage
The .Rscript file "Cleaning and Theoretical Models" is used to extract the analysis datasets from this repository and load them into R. The script then cleans and prepares key variables from the analysis datasets for use in our models. Finally, the script runs and summarizes five logistic models that study a range of potentially influential features. 

The. Rscript file GLM Prediction Model partitions the data into 70/15/15 train, validate, and test datasets and uses binomial GLM to predict recidivism. Mean F1 is used to measure error in our predictions. Multiple cutoffs are tested and confusion matrixes are generated to examine the tradeoff between sensitivity and specificity in our model.

To run this script change the working directory to your preferred working directory, and install the package "memisc". This package is used in this script to simplify recoding of variables from survey data. 

Future scripts will set up a k-folds approach as an alternative to the 70/15/15 partition, and test the predictive accuracy of decision trees, a random forest, and KNN approach in comparision to our GLM approach. 

## Progress Log
- Project data identified and downloaded 3/28/17
- Project proposal submitted 3/29/17
- Project github repo initialized 4/11/17
- Data and codebook uploaded to repo 4/11/17
- Upload .csv and .Rda versions of datasets for easier use 4/21/17
- Upload .Rscript file that sets up data and runs theoretical models 4/24/17
- Upload .Rscript file that uses GLM to predict recidvisim and measures accuracy with Mean F1 5/5/17
- Upload .Rscript files that test decision trees, KNN, and random forest 5/7/17

## Credits
Credit to Viola Hilbert, Shashank Shekhr Rai, and Seth Taylor.

## License
Due to the potentially sensitive ethical nature of this work, we maintain exclusive copyright within the Github Terms of Service. 
