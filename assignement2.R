library(lubridate)
####Download data and documentation, create log file and load the data in R
link_data <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
link_doc1 <- "https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf"
link_doc2 <- "https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf"
date <- date()
#create directory for raw data
if(!file.exists("./raw_data")) {
      dir.create("./raw_data")
}
#download data and create log file of the download
if(!file.exists("./raw_data/StormData.csv.bz2")) {
      link <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
      date <- date()
      log <- paste("Data downloaded from:", link, "on", date, sep = " ")
      write.table(log, "./raw_data/data_access_log.txt")
      download.file(link_data, 
                    "./raw_data/StormData.csv.bz2", 
                    method = "curl")
      rm(date, link, log)
}
#download documentation
if(!file.exists("./raw_data/StormDataDoc.pdf")) {
      download.file(link_doc1, 
                    "./raw_data/StormDataDoc.pdf", 
                    method = "curl")
}
if(!file.exists("./raw_data/StormDataFAQ.pdf")) {
      download.file(link_doc2, 
                    "./raw_data/StormDataFAQ.pdf", 
                    method = "curl")
}

#read the data
if(!exists("StormData")) {
      StormData <- read.csv(bzfile("./raw_data/StormData.csv.bz2"), stringsAsFactors = FALSE, header = TRUE)
}

rm(link, link_doc1, link_doc2)


#analysis of the dataset
#EVTYPE.txt is a list of the EVTTYPE taken from the documentation downloaded as StormDataDoc.pdf (p.6, table 1. Storm Data Event Table)
evtype_doc <- scan("./raw_data/EVTYPE.txt", what = "", sep = "\n")#read the lisst
evtype_doc <- substr(evtype_doc, 1, nchar(evtype_doc) - 2)#remove the character "designator"
evtype_data <- levels(df$EVTYPE)
cbind(EVTYPE.DOCUMENTATION = length(categories), EVTYPE.DATA = length(levels(df$EVTYPE)))
print(evtype_doc)
print(evtype_data)
#cleaning EVTYPE
#let's start with the levels "summary"
#read the remarks
row_summary <- grep("Summary" ,df$evtype, ignore.case = TRUE)
df[row_summary,]
dates_summary <- df[0,] 
for(i in 1:length(row_summary)){
      index <- grep(df$bgn_date[row_summary[i]], df$bgn_date[year(df$bgn_date) > 1995])
      rbind(dates_summary, df[index, ])
} 
#Pre-processing

df <- with(StormData, 
           data.frame(state = STATE,
                      bgn_date = as.Date(as.character(StormData$BGN_DATE), format = "%m/%d/%Y"),
                      evtype = as.factor(EVTYPE), 
                      fatalities = FATALITIES, 
                      injuries = INJURIES, 
                      propdmg = PROPDMG, 
                      propdmgexp = PROPDMGEXP, 
                      cropdmg = CROPDMG, 
                      cropdmgexp = CROPDMGEXP,
                      remarks = REMARKS)
           )

