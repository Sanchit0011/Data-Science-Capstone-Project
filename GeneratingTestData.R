#Reading lines from the US blogs text file into R
con <- file("C:/CapstoneProject/final/en_US/en_US.blogs.txt", "r")
blog <- readLines(con)
close(con)

#Generating a reproducible sample test subset from the US blogs text file 
set.seed(123)
testblog <- blog[rbinom(length(blog)*0.01113, length(blog), 0.5)]
testblog <- iconv(testblog, "latin1", "ASCII", sub="")

#Reading lines from the US twitter text file into R
con1 <- file("C:/CapstoneProject/final/en_US/en_US.twitter.txt", "r")
twitter <- readLines(con1)
close(con1)

#Generating a reproducible sample test subset from the US twitter text file
set.seed(456)
testtwitter <- twitter[rbinom(length(twitter)*0.00424, length(twitter), 0.5)]
testtwitter <- iconv(testtwitter, "latin1", "ASCII", sub="")

#Reading lines from the US news text file into R
con2 <- file("C:/CapstoneProject/final/en_US/en_US.news.txt", "rb")
news <- readLines(con2)
close(con2)

#Generating a reproducible sample train subset from the US news text file
set.seed(789)
testnews <- news[rbinom(length(news)*0.01, length(news), 0.5)]
testnews <- iconv(samplenews, "latin1", "ASCII", sub="")

TestData <- VCorpus(VectorSource(c(testblog,testnews,testtwitter)))

#Removing non-alpha numeric characters from corpus
removeNonAlphaChar <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
TestData <- tm_map(TestData, removeNonAlphaChar, '[^[:alpha:][:space:][:punct:]]')

#Removing urls from each file in the corpus
removeUrl <- content_transformer(function(x, pattern) gsub(pattern, '', x, ignore.case = TRUE))
TestData <- tm_map(TestData, removeUrl, '(ftp|http)\\S+\\s*')

#Removing e-mail ids from each file in the corpus
removeEmail <- content_transformer(function(x, pattern) str_replace_all(x, pattern, ''))
TestData <- tm_map(TestData, removeEmail, "[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+")

#Removing twitter tags from each file in the corpus
removeTT <- content_transformer(function(x, pattern) gsub(pattern, '', x))
TestData <- tm_map(TestData, removeTT, "RT |via")

#Removing twitter hash tags from each file in the corpus
removeHT <- content_transformer(function(x, pattern) gsub(pattern, '', x))
TestData <- tm_map(TestData, removeHT, "#[a-z,A-Z]*")

#Removing html entities from corpus
removeAmp <- content_transformer(function(x, pattern) gsub(pattern, '', x))
TestData <- tm_map(TestData, removeAmp, "&amp")

#Removing numbers from each file in the corpus
TestData <- tm_map(TestData, removeNumbers)

#Removing punctuation from each file in the corpus
TestData <- tm_map(TestData, removePunctuation)

#Removing stop words from each file in the corpus
TestData <- tm_map(TestData, removeWords, stopwords("en"))

#Converting text to lower case
TestData <- tm_map(TestData, content_transformer(tolower))

#Removing profane words from each text file in the corpus
profaneWords <- read.table("bad_words.txt", header = FALSE, quote = "", sep = "\n", strip.white = TRUE)
TestData <- tm_map(TestData, removeWords, profaneWords[,1])

#Removing extra whitespace from the corpus
TestData <- tm_map(TestData, stripWhitespace)

