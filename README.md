# Data-Science-Capstone-Project

## Introduction
This is the capstone project for the Coursera Data Science Specialization, taught by professors from John Hopkins University and is in collaboration with Swiftkey, a text prediction app company. The project is a text prediction shiny application which identifies three words most likely of being the next word of a user specified incomplete sentence. The algorithm uses the n-gram backoff model concept.

## Data

The data sets I had to work with as part of this project were three text files containing english twitter, blog and news data.


## Steps

1.) First, the three text files were loaded into the R environment. Since the files were too large to be processed, a 25% random subset was extracted from each file. These subsets would serve as the training data sets for the model.

2.) The sample training sets were combined into a single corpus. The corpus was then cleansed by removing non alphanumeric characters, punctuation, numbers, urls, emails, stop words, profane words, etc.

The first two steps are accomplished in the **CapstoneProject.R script**.

3.) Unigram, bigrams, trigrams and fourgrams are extracted from the corpus. They are extracted in the form of data frames and are ordered in decreasing order of frequency. This is accomplished in the **ExtractNGram.R** script.



