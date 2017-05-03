
library(quanteda)
library(quantedaData)
library(lsa)
library(NLP)
library(tm)
library(RTextTools)
library(tidytext)

#call news corpus 
news_corp = data_corpus_immigrationnews
#create table of count of texts by paper
news_count.df = aggregate(texts ~ paperName, data=as.data.frame(news_corp$documents), FUN=length)
#place in descending order 
news_count.df = news_count.df[with(news_count.df, order(news_count.df$texts, decreasing=TRUE)),]
top_four = news_count.df[1:4, 1]
# #create df of corpus and subset just top four papers
# news_df = as.data.frame(news_corp$documents)
# news_df <- news_df[news_df$paperName %in% top_four ,]
# #create unique identifier 
# news_df$PaperID <- paste(news_df$paperName, news_df$id, sep="_")
# #create corpus object 
# corp_reader <- readTabular(mapping=list(content="texts", id="PaperID"))
# corp<- VCorpus(DataframeSource(news_df), readerControl=list(reader=corp_reader))
# corp <- tm_map(corp, content_transformer(tolower))
# corp <- tm_map(corp, content_transformer(removePunctuation))
# corp <- tm_map(corp, removeWords, custom_stopwords)
# news_dtm<- DocumentTermMatrix(corp)

corp = corpus_subset(news_corp, subset=news_corp$documents$paperName %in% top_four, select=c(paperName, id, day))
news_dfm <- dfm(tokenize(corp, remove_punct=TRUE), tolower=TRUE, remove=custom_stopwords)
news_dfm <- dfm_trim(news_dfm, min_count=30, min_docfreq=20)
ndoc(news_dfm)
sum(ntoken(news_dfm))

