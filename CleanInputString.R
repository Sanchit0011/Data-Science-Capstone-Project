#Defining function to clean user specified input string 
cleanInputString <- function(inputString) {
  #Removing non-alpha numeric characters from input string
  inputString <- iconv(inputString, "latin1", "ASCII", sub=" ")
  inputString <- gsub("[^[:alpha:][:space:][:punct:]]", "", inputString)

  #Convert input string to a Corpus
  inputStringCorpus <- VCorpus(VectorSource(inputString))
  
  #Convert the input string to lower case
  #Remove punctuations, numbers, non alphabetic characters white spaces from the input string
  inputStringCorpus <- tm_map(inputStringCorpus, content_transformer(tolower))
  inputStringCorpus <- tm_map(inputStringCorpus, removePunctuation)
  inputStringCorpus <- tm_map(inputStringCorpus, removeNumbers)
  inputStringCorpus <- tm_map(inputStringCorpus, stripWhitespace)
  inputString <- as.character(inputStringCorpus[[1]])
  inputString <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", inputString)
  
  #Return the resulting cleansed string
  #If the resulting string is empty then we return and empty string
  if (nchar(inputString) > 0) {
    return(inputString); 
  } else {
    return("");
  }
  
  
}
