con <- file("C:/CapstoneProject/final/en_US/en_US.blogs.txt", "r")
sample1 <- readLines(con,500)
close(con)

sample <- gsub('(ftp|http)\\S+\\s*', '', a, ignore.case = TRUE)
sample <- gsub('[^a-zA-Z]', " ", a)
sample <- str_replace_all(a,"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+", "")
sasasamplcleanData <- gsub('[[:digit:]]+', '', cleanData)
cleanData <- str_replace_all(sample, "[^a-zA-Z]", " ")
cleanData

library(tokenizers)
tokenizedData <- tokenize_words(cleanData)
tokenizedData <- unlist(tokenizedData)
tokenizedData


#Combining all 3 sample subsets into a Corpus
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

removeUrl <- content_transformer(function(x, pattern) gsub(pattern, '', x, ignore.case = TRUE))
SampleData <- tm_map(SampleData, removeUrl, '(ftp|http)\\S+\\s*')

html2txt <- function(str) {
  xpathApply(htmlParse(str, asText=TRUE),
             "//body//text()", 
             xmlValue)[[1]] 
}
SampleData1 <- html2txt(SampleData)
