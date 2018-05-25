# load packages
library(tm)

readTheInput <- function (yourInputText) {

# read text and output matrix of word frequencies ** ONLY ACCEPTING TXT FOR THE MOMENT
text <- readLines(yourInputText,encoding="UTF-8")

myCorpus = Corpus(VectorSource(text))
myCorpus = tm_map(myCorpus, content_transformer(tolower))
myCorpus = tm_map(myCorpus, removePunctuation)
myCorpus = tm_map(myCorpus, removeNumbers)
myCorpus = tm_map(myCorpus, removeWords, stopwords("english"))

myDTM = TermDocumentMatrix(myCorpus,control = list(minWordLength = 1))
m = as.matrix(myDTM)
freq=sort(rowSums(m), decreasing = TRUE)
ff=as.data.frame(freq)
ff[,"word"]=rownames(ff)

return(ff)
}
