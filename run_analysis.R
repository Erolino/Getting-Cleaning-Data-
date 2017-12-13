## Getting and Cleanning course data final project.

## creates the directory (if needed) to save the files into
if (!file.exists("final_project")) {
  dir.create("final_project")
}
## download file into the current wd
downURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(downURL,destfile = "./final_project/final_project.zip",method = "curl")
## the date of downloading
downDate<-date()

## Check what directory you are in right now. it should be:
setwd("/Users/Eran/datasciencecoursera/Getting & Cleanning Data/final_project")
## obtainning labels and subject numbers
features<-read.table("features.txt")
activitylabels<-read.table("activity_labels.txt")

## obtain the TRAIN and Test data
## TRAIN:
setwd("/Users/Eran/datasciencecoursera/Getting & Cleanning Data/final_project/train")
X_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
subject_train<-read.table("subject_train.txt")
## Test:
setwd("/Users/Eran/datasciencecoursera/Getting & Cleanning Data/final_project/test")
X_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")
subject_test<-read.table("subject_test.txt")

##### 1. ARRANGE THE Test DATA ####
## Give names to the data cols according to the features names
feat<-as.character(features[,2])
X_testNam<-X_test
names(X_testNam)<-feat
## adding subjectNumber as the first column of the data. Note classes (character, data frame)
## conversions:
namm<-"subjectNum"
subject_testDF<-as.data.frame(subject_test)
names(subject_testDF)<-namm
X_testNamSub<-X_testNam
X_testNamSub<-cbind(subject_testDF,X_testNamSub)
y_test1<-y_test
## Turnning labels vec into activity (in words)
for (ii in 1:6) {
  y_test1[which(y_test1==ii),1]<-as.character(activitylabels[ii,2])
}
lab<-"activity_labels"
y_test1DF<-as.data.frame(y_test1)
names(y_test1DF)<-lab
X_testNamSubLab<-X_testNamSub
## test data with 1st col as subject num and last col as explicit labes. 
## and all the variables are named
X_testNamSubLab<-cbind(X_testNamSubLab,y_test1DF)

##### 2. ARRANGE THE TRAIN DATA ####
## Give names to the data cols according to the features names
feat<-as.character(features[,2])
X_trainNam<-X_train
names(X_trainNam)<-feat
## adding subjectNumber as the first column of the data. Note classes (character, data frame)
## conversions:
nammtr<-"subjectNum"
subject_trainDF<-as.data.frame(subject_train)
names(subject_trainDF)<-nammtr
X_trainNamSub<-X_trainNam
X_trainNamSub<-cbind(subject_trainDF,X_trainNamSub)
y_train1<-y_train
## Turnning labels vec into activity (in words)
for (ii in 1:6) {
  y_train1[which(y_train1==ii),1]<-as.character(activitylabels[ii,2])
}
lab<-"activity_labels"
y_train1DF<-as.data.frame(y_train1)
names(y_train1DF)<-lab
X_trainNamSubLab<-X_trainNamSub
## test data with 1st col as subject num and last col as explicit labes. 
## and all the variables are named
X_trainNamSubLab<-cbind(X_trainNamSubLab,y_train1DF)

## 3. MERGE TRAIN AND TEST DATA
X_traintest<-rbind(X_trainNamSubLab,X_testNamSubLab)

## 4. LEAVE IN ONLY "MEAN" AND "STD" DATA
meanind<-grep("mean",names(X_traintest))
stdind<-grep("std",names(X_traintest))
inds<-sort(c(meanind,stdind))
dataMSTD<-X_traintest[,inds]
dataMSTDn<-cbind(subjectNum=X_traintest[,1],dataMSTD,activity_label=X_traintest[,563])

## 5. 
setwd("..")
## orders the table according to subject number
dataMSTDor<-dataMSTDn[order(dataMSTDn$subjectNum),]
## different way to do it through 'dplyr' package:
library("dplyr")
## grouping the data accrording to the number of subject and type of label
## for each (using dplyr):
bysublab<-group_by(dataMSTDn,subjectNum,activity_label)
##creating a table of averages of variables depended on labels, and subjects
sublabmean<-summarise_at(bysublab,c(1:79),mean)
cleanData<-write.table(sublabmean,row.names = FALSE)
