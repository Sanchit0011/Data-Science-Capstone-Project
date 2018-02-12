#Generates random substring and its next word from text
randomSubstring <- function(text) {
  # convert characters to a vector
  stringSplit <- unlist(strsplit(text, " "))
  start <- as.integer(runif(1, 1, length(stringSplit) - 1))
  length <- as.integer(runif(1, 1, length(stringSplit) - start + 1))
  sub <- paste(stringSplit[start:(start + length - 1)], collapse=" ")
  Next <- paste(stringSplit[(start + length):(start + length)],
                   collapse=" ")
  list("sub"=sub, "nxt"= Next)
}

## count the number of words in the character string provided
wordCount <- function(text) {
  length(unlist(strsplit(text, " ")))
}




ptm <- proc.time()
success <- 0
invalid <- 0
for(i in 1:length(TestData)) {
  testText <- TestData[[i]]$content
  
  # exclude testing texts with only a single word (e.g. nothing to predict!)
  if(wordCount(testText) > 1) {
    randomSub <- randomSubstring(testText)
    if(randomSub$nxt %in% PredictNextWord(randomSub$sub)$nextWord){
      success = success + 1
  }
    else {
      invalid <- invalid + 1 # count of invalid tests
    }
 }
}
accuracy <- success / (success + invalid) * 100
time <- proc.time() - ptm

list("accuracy"=accuracy, "time"=time)
