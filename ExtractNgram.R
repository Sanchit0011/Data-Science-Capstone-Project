#Creating unigram dataframe
term_doc_mat <- TermDocumentMatrix(SampleData)
a <- as.matrix(term_doc_mat)
b <- rowSums(a)
unigram <- as.data.frame(b)
colnames(unigram) <- c("freq")
unigram$term <- rownames(unigram)
unigram <- arrange(unigram,desc(freq))

#Exploring the unigram dataframe
dim(unigram)
summary(unigram)
str(unigram)

#Displaying first 10 rows of unigram dataframe
head(unigram, 10)

#Displaying last 10 rows of unigram dataframe
tail(unigram, 10)

#Plotting the frequency of top 20 unigrams
barplot(unigram[1:20,1], names.arg = unigram[1:20,2], cex.names = 0.70, cex.axis = 0.80, col = "red", las = 2)

#Creating bigram dataframe
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
term_doc_mat2 <- TermDocumentMatrix(SampleData, control = list(tokenize = BigramTokenizer))
c <- as.matrix(term_doc_mat2)
d <- rowSums(c)
bigram <- as.data.frame(d)
colnames(bigram) <- c("freq")
bigram$term <- rownames(bigram)
bigram <- arrange(bigram,desc(freq))

#Exploring the bigram dataframe
dim(bigram)
summary(bigram)
str(bigram)

#Displaying first 10 rows of bigram dataframe
head(bigram, 10)

#Displaying last 10 rows of bigram dataframe
tail(bigram, 10)

#Plotting the frequency of top 20 bigrams
barplot(bigram[1:20,1], names.arg = bigram[1:20,2], cex.names = 0.70, cex.axis = 0.80, col = "blue", las = 2)

#Creating trigram dataframe
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
term_doc_mat3 <- TermDocumentMatrix(SampleData, control = list(tokenize = TrigramTokenizer))
term_doc_mat3 <- removeSparseTerms(term_doc_mat3, 0.66) 
e <- as.matrix(term_doc_mat3)
f <- rowSums(e)
trigram <- as.data.frame(f)
colnames(trigram) <- c("freq")
trigram$term <- rownames(trigram)
trigram <- arrange(trigram,desc(freq))

#Exploring the trigram dataframe
dim(trigram)
summary(trigram)
str(trigram)

#Displaying first 10 rows of trigram dataframe
head(trigram, 10)

#Displaying last 10 rows of trigram dataframe
tail(trigram, 10)

#Plotting the frequency of top 20 trigrams
barplot(trigram[1:20,1], names.arg = trigram[1:20,2], cex.names = 0.70, cex.axis = 0.80, col = "green", las = 2)

#Creating fourgram dataframe
FourgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
term_doc_mat4 <- TermDocumentMatrix(SampleData, control = list(tokenize = FourgramTokenizer))
term_doc_mat4 <- removeSparseTerms(term_doc_mat4, 0.70)
g <- as.matrix(term_doc_mat4)
h <- rowSums(g)
fourgram <- as.data.frame(h)
colnames(fourgram) <- c("freq")
fourgram$term <- rownames(fourgram)
fourgram <- arrange(fourgram,desc(freq))

#Exploring the fourgram dataframe
dim(fourgram)
summary(fourgram)
str(fourgram)

#Displaying first 10 rows of fourgram dataframe
head(fourgram, 10)

#Displaying last 10 rows of fourgram dataframe
tail(fourgram, 10)


#Plotting the frequency of top 20 fourgrams
barplot(fourgram[1:20,1], names.arg = fourgram[1:20,2], cex.names = 0.70, cex.axis = 0.80, col = "yellow", las = 2)

