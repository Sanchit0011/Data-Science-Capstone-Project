suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))

load("unigram.Rdata");
load("bigram.Rdata");
load("trigram.Rdata");
load("fourgram.Rdata");
message <- as.character(NULL);

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


#Defining function to specify three words most likely of being the 
#next word of the user specified string
PredictNextWord <- function(inputString)
{
  assign("message", "in PredictNextWord", envir = .GlobalEnv)
  
  #Clean up the user specified input string
  inputString <- cleanInputString(inputString);
  
  #Split the input string across white spaces and then extract the length
  inputString <- unlist(strsplit(inputString, split=" "));
  inputStringLength <- length(inputString);
  
  nextWordFound <- FALSE;
  predNextWord <- as.character(NULL);
  #message <<- as.character(NULL);
  
  #First test the four gram model using the fourgram dataframe
  if (inputStringLength >= 3 & !nextWordFound)
  {
    #Extract the last three words from the user specified input string
    inputString1 <- paste(inputString[(inputStringLength-2):inputStringLength], collapse=" ");
    
    #Subset the fourgram dataframe using the extracted words  
    searchString <- paste("^",inputString1, sep = "");
    fourgram1 <- fourgram[grep (searchString, fourgram$term), ];
    
    #Check to see if any matching rows are returned and assign the words 
    #corresponding to the first three rows and second column of the fourgram1 dataframe
    #as the three words most likely of being the next word
    if ( length(fourgram1[, 1]) > 1 )
    {
      predNextWord <- fourgram1[1:3,2];
      nextWordFound <- TRUE;
      message <<- "Next word is predicted using fourgram."
    }
    fourgram1 <- NULL;
  }
  
  
  
  #If fourgram isn't found, test the trigram model using the trigram data frame
  if (inputStringLength >= 2 & !nextWordFound)
  {
    #Extract the last two words of the user specified string
    inputString1 <- paste(inputString[(inputStringLength-1):inputStringLength], collapse=" ");
    
    #Subset the trigram dataframe using the extracted words  
    searchString <- paste("^",inputString1, sep = "");
    trigram1 <- trigram[grep (searchString , trigram$term), ];
    
    #Check to see if any matching rows are returned and assign the words 
    #corresponding to the first three rows and second column of the trigram1 dataframe
    #as the three words most likely of being the next word
    if (length(trigram1[, 1]) > 1)
    {
      predNextWord <- trigram1[1:3,2];
      nextWordFound <- TRUE;
      message <<- "Next word is predicted using trigram."
    }
    trigram1 <- NULL;
  }
  
  #If trigram isn't found, test the bigram model using the bigram dataframe 
  if (inputStringLength >= 1 & !nextWordFound)
  {
    #Extract the last word of the user specified string
    inputString1 <- paste(inputString[inputStringLength], collapse=" ");
    
    #Subset the bigram dataframe using the extracted word 
    searchString <- paste("^",inputString1, sep = "");
    bigram1 <- bigram[grep (searchString, bigram$term), ];
    
    #Check to see if any matching rows are returned and assign the words 
    #corresponding to the first three rows and second column of the bigram1 dataframe
    #as the three words most likely of being the next word
    if ( length(bigram1[, 1]) > 1 )
    {
      predNextWord <- bigram1[1:3,2];
      nextWordFound <- TRUE;
      message <<- "Next word is predicted using bigram."
    }
    bigram1 <- NULL;
  }
  
  
  #If no fourgram, trigram or bigram is found return the 3 most
  #frequently used terms from the unigram data frame 
  if (!nextWordFound & inputStringLength > 0)
  {
    predNextWord <- unigram$term[1:3];
    message <- "No next word found, the most frequent word is selected as next word."
  }
  
  nextWord <- word(predNextWord, -1);
  
  if (inputStringLength > 0){
    df1 <- data.frame(nextWord, message);
    return(df1);
  } else {
    nextWord <- "";
    message <-"";
    df1 <- data.frame(nextWord, message);
    return(df1);
  }
}

message <- ""
shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    str2 <- cleanInputString(input$inputString);
    strDF <- PredictNextWord(str2);
    input$action;
    message <- as.character(strDF[1,2]);
    cat("", as.character(strDF[1:3,1]))
    cat("\n\t");
    cat("\n\t");
    cat("Note: ", as.character(strDF[1,2]));
  })
  
  output$text1 <- renderText({
    paste("Input Sentence: ", input$inputString)});
  
  output$text2 <- renderText({
    input$action;
    #paste("Note: ", msg);
  })
}
)
