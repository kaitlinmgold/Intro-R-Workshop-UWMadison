getwd()
list.files(".")
wcData <- read.csv("data/Intro to R for Plant Pathologists Workshop RSVP.csv", stringsAsFactors = FALSE)

install.packages("SnowballC")

library(wordcloud)
library(SnowballC)
library(RColorBrewer)

colnames(wcData)[5] <- "experience"

wcDataCorpus <- Corpus(VectorSource(wcData$experience))

wcDataCorpus <- tm_map(wcDataCorpus, removeWords, c('and', 'this', stopwords('english')))


wcDataCorpus <- Corpus(VectorSource(wcDataCorpus))
wordcloud(wcDataCorpus,max.words=100, random.order = FALSE, min.freq=1)

dtm <- TermDocumentMatrix(wcDataCorpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)
