library(jsonlite)
library(tm)

#set the working dataspace
setwd("D:/UNIV NOTES/Y4S1/DSA4199/genre_classification/workspace")
dataset_wkspc <- file.path(getwd(), "gb_input")
wkspc <- file.path(dataset_wkspc, 'data_index.json')

#read the data and preprocess it
data <- fromJSON(readLines(wkspc), flatten = TRUE)
corpus <- VCorpus(VectorSource(data$body))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, function(x) gsub("\r\n", " ", x))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, tolower)
stem.corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, PlainTextDocument)
dtm <<- DocumentTermMatrix(corpus)
stem.dtm <<- DocumentTermMatrix(stem.corpus)

#dtm.df <<- as.data.frame(data.matrix(dtm), stringsAsfactors = FALSE)
#stem.dtm.df <<- as.data.frame(data.matrix(stem.dtm), stringsAsfactors = FALSE)

#remove sparse term where the term is nonexistent in more than 80% of the data
sparse.dtm <<- removeSparseTerms(dtm, 0.8)
sparse.stem.dtm <<- removeSparseTerms(stem.dtm, 0.8)
sparse.dtm.df <<- as.data.frame(data.matrix(sparse.dtm), stringsAsfactors = FALSE)
sparse.stem.dtm.df <<- as.data.frame(data.matrix(sparse.stem.dtm), stringsAsfactors = FALSE)

#write to csv
write.csv(sparse.dtm.df, "full_corpus.csv", row.names = FALSE)
write.csv(sparse.stem.dtm.df, "full_stem_corpus.csv", row.names = FALSE)
