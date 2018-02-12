#Loading the required packages
library(tm)
library(stringr)
library(stringi)
library(stylo)
library(RWeka)
library(dplyr)

#Downloading the Data
fileUrl <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(fileUrl, destfile = "C:/CapstoneProject/projectdata")
unzip(zipfile = "C:/CapstoneProject/projectdata", exdir = "C:/CapstoneProject") 

#Reading lines from the US blogs text file into R
con <- file("C:/CapstoneProject/final/en_US/en_US.blogs.txt", "r")
blog <- readLines(con)
close(con)

#Generating a reproducible sample train subset from the US blogs text file 
set.seed(1)
sampleblog <- blog[rbinom(length(blog)*0.25, length(blog), 0.5)]
sampleblog <- iconv(sampleblog, "latin1", "ASCII", sub="")
write.csv(sampleblog,"C:/CapstoneProject/SampleData/sampleblog.csv", row.names = FALSE,
          col.names = FALSE)

#Reading lines from the US twitter text file into R
con1 <- file("C:/CapstoneProject/final/en_US/en_US.twitter.txt", "r")
twitter <- readLines(con1)
close(con1)

#Generating a reproducible sample train subset from the US twitter text file
set.seed(2)
sampletwitter <- twitter[rbinom(length(twitter)*0.25, length(twitter), 0.5)]
sampletwitter <- iconv(sampletwitter, "latin1", "ASCII", sub="")
write.csv(sampletwitter,"C:/CapstoneProject/SampleData/sampletwitter.csv", row.names = FALSE,
          col.names = FALSE)

#Reading lines from the US news text file into R
con2 <- file("C:/CapstoneProject/final/en_US/en_US.news.txt", "rb")
news <- readLines(con2)
close(con2)

#Generating a reproducible sample train subset from the US news text file
set.seed(3)
samplenews <- news[rbinom(length(news)*0.25, length(news), 0.5)]
samplenews <- iconv(samplenews, "latin1", "ASCII", sub="")
write.csv(samplenews,"C:/CapstoneProject/SampleData/samplenews.csv", row.names = FALSE,
          col.names = FALSE)

#Displaying general statistics about the sampleblog text file
blogStats <- stri_stats_general(sampleblog)
blogStats

#Displaying general statistics about the sampleblog text file
newsStats <- stri_stats_general(samplenews)
newsStats

#Displaying general statistics about the sampleblog text file
twitterStats <- stri_stats_general(sampletwitter)
twitterStats

#Combining statistics of all files in one variable
DataStats <- rbind(blogStats, newsStats, twitterStats)
DataStats

#Converting DataStats into a data frame object
DataStats <- as.data.frame(DataStats)

#Giving rows of the DataStats data fram proper names
rownames(DataStats) <- c("blog", "news", "twitter")

#Creating a barplot depicting the number of lines in each file
barplot(DataStats[,1], names.arg = rownames(DataStats), main = "Number of lines in each file", xlab = "File", ylab = 
          "Number of Lines", col = c("red", "green", "blue"))

#Creating a barplot depicting the number of characters in each file
barplot(DataStats[,3], names.arg = row.names(DataStats), main = "Number of characters in each file", xlab = "File", ylab = 
          "Number of characters", col = c("purple", "brown", "yellow"))

#Creating a barplot depicting the number of  that aren't white spaces in each file
barplot(DataStats[,4], names.arg = row.names(DataStats), main = "Number of characters that aren't white spaces in each file", xlab = "File", ylab = 
          "Number of characters(not whitespaces)", col = c("orange", "black", "grey"))


#Combining all 3 sample train subsets into a Corpus
SampleData <- VCorpus(DirSource("C:/CapstoneProject/SampleData/"), readerControl = list(language="en_US"))

#Printing out the number of documents in the corpus
length(SampleData)

#Printing out the details of the corpus
summary(SampleData)

#Printing out the metadata of each document in the corpus
meta(SampleData[[1]])
meta(SampleData[[2]])
meta(SampleData[[3]])

#Printing out the number of characters in each document of the corpus
length(SampleData[[1]]$content)
length(SampleData[[2]]$content)
length(SampleData[[3]]$content)

#Printing first line of each document in the corpus
SampleData[[1]]$content[1]
SampleData[[2]]$content[1]
SampleData[[3]]$content[1]

#Removing non-alpha numeric characters from corpus
removeNonAlphaChar <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
SampleData <- tm_map(SampleData, removeNonAlphaChar, '[^[:alpha:][:space:][:punct:]]')

#Removing urls from each file in the corpus
removeUrl <- content_transformer(function(x, pattern) gsub(pattern, '', x, ignore.case = TRUE))
SampleData <- tm_map(SampleData, removeUrl, '(ftp|http)\\S+\\s*')

#Removing e-mail ids from each file in the corpus
removeEmail <- content_transformer(function(x, pattern) str_replace_all(x, pattern, ''))
SampleData <- tm_map(SampleData, removeEmail, "[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+")

#Removing twitter tags from each file in the corpus
removeTT <- content_transformer(function(x, pattern) gsub(pattern, '', x))
SampleData <- tm_map(SampleData, removeTT, "RT |via")

#Removing twitter hash tags from each file in the corpus
removeHT <- content_transformer(function(x, pattern) gsub(pattern, '', x))
SampleData <- tm_map(SampleData, removeHT, "#[a-z,A-Z]*")

#Removing html entities from corpus
removeAmp <- content_transformer(function(x, pattern) gsub(pattern, '', x))
SampleData <- tm_map(SampleData, removeAmp, "&amp")

#Removing numbers from each file in the corpus
SampleData <- tm_map(SampleData, removeNumbers)

#Removing punctuation from each file in the corpus
SampleData <- tm_map(SampleData, removePunctuation)

#Removing stop words from each file in the corpus
SampleData <- tm_map(SampleData, removeWords, stopwords("en"))

#Converting text to lower case
SampleData <- tm_map(SampleData, content_transformer(tolower))

#Removing profane words from each text file in the corpus
profaneWords <- read.table("bad_words.txt", header = FALSE, quote = "", sep = "\n", strip.white = TRUE)
SampleData <- tm_map(SampleData, removeWords, profaneWords[,1])

#Removing extra whitespace from the corpus
SampleData <- tm_map(SampleData, stripWhitespace)

#Convert corpus into a vector of text
myData <- txt.to.words(SampleData)

#Displaying the 100 most frequent words in the entire corpus
freqlist <- make.frequency.list(myData, head = 100)
freqlist


