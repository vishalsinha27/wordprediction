library("tm")
library("stringi")
library("SnowballC")
library("rJava")
options( java.parameters = "-Xmx8g" )
.jinit(parameters="-Xmx8000m")
library("RWeka")
library("dplyr")
library("ggplot2")
blogFile <- "final/en_US/en_US.blogs.txt"
twitterFile <- "final/en_US/en_US.twitter.txt"
newsFile <- "final/en_US/en_US.news.txt"
blog <- readLines(blogFile)
twitter <- readLines(twitterFile)
news <- readLines(newsFile)
blog<-iconv(blog,from='latin1',to ='ASCII',sub="")
twitter<-iconv(twitter,from='latin1',to ='ASCII', sub="")
news<-iconv(news,from='latin1',to ='ASCII',sub="")

set.seed(1234) 
x <- 4
lengthBlog <- length(blog)
lengthTwitter <- length(twitter)
lengthNews <- length(news)
startBlog <- 1
startTwitter <- 1
startNews <- 1
endBlog <- lengthBlog/x
endTwitter <- lengthTwitter/x
endNews <- lengthNews/x

numItems <- 20000
twittersample <- vector("list", x)
newssample <- vector("list", x)
blogsample <- vector("list", x)
merged <- vector("list", x)
for(i in 1:x) {
print(paste("calculting blog for x = ",x, "  start = ",startBlog, "  end = ",endBlog))
blogsample[[i]]<-blog[sample(startBlog:endBlog,numItems,replace=FALSE)]
print(paste("calculting twitter for x = ",i, "  start = ",startTwitter, "  end = ",endTwitter))
twittersample[[i]]<-twitter[sample(startTwitter:endTwitter,numItems,replace=FALSE)]
newssample[[i]]<-news[sample(startNews:endNews,numItems,replace=FALSE)]
startBlog <-   endBlog +1
startTwitter <- endTwitter+1
startNews <- endNews +1
endBlog <- endBlog + lengthBlog/x
endTwitter <- endTwitter + lengthTwitter/x
endNews <- endNews + lengthNews/x
merged[[i]]<-rbind(blogsample[[i]],twittersample[[i]],newssample[[i]])



}
rm(blog,news,twitter)
#merge the data
for(i in 1:x) {
print(paste(" calculating for i= ", i))  
docs <- VCorpus(VectorSource(merged[[i]]))
# make it lower case
docs <- tm_map(docs,content_transformer(tolower))
#remove punctuation
docs <- tm_map(docs, removePunctuation)
#remove numbers
docs <- tm_map(docs, removeNumbers)
#remove extra whitespaces.
docs <- tm_map(docs, stripWhitespace)
#create a dataframe.
dataframe<-data.frame(text=unlist(sapply(docs,`[`,"content")), stringsAsFactors=F)
print(paste("calculating one gram "))
onegram<-NGramTokenizer(dataframe,Weka_control(min=1,max=1))
onedf<-data.frame(table(onegram))
finalOneDf <- arrange(onedf,desc(Freq))
save(finalOneDf, file = paste("oneDf_",i,".rda", sep=""))
rm(finalOneDf,onedf,onegram)
print(paste("file written for 1 gram ",i))

twogram<-NGramTokenizer(dataframe,Weka_control(min=2,max=2))
twodf<-data.frame(table(twogram))
finalTwoDf <- arrange(twodf,desc(Freq))
save(finalTwoDf, file = paste("twoDf_",i,".rda", sep=""))
rm(finalTwoDf,twodf,twogram)
print(paste("file written for 2 gram ",i))

threegram<-NGramTokenizer(dataframe,Weka_control(min=3,max=3))
threedf<-data.frame(table(threegram))
finalThreeDf <- arrange(threedf,desc(Freq))
save(finalThreeDf, file = paste("threeDf_",i,".rda", sep=""))
rm(finalThreeDf,threegram,threedf)
print(paste("file written for 3 gram ",i))

fourgram<-NGramTokenizer(dataframe,Weka_control(min=4,max=4))
fourdf<-data.frame(table(fourgram))
finalFourDf <- arrange(fourdf,desc(Freq))
save(finalFourDf, file = paste("fourDf_",i,".rda", sep=""))
rm(finalFourDf,fourdf,fourgram)
print(paste("file written for 4 gram ",i))

fivegram<-NGramTokenizer(dataframe,Weka_control(min=5,max=5))
fivedf<-data.frame(table(fivegram))
finalFiveDf <- arrange(fivedf,desc(Freq))
save(finalFiveDf, file = paste("fiveDf_",i,".rda", sep=""))
rm(finalFiveDf,fivedf,fivegram)
print(paste("file written for 5 gram ",i))


}

grep("^about taking", threedf$threegram, value = TRUE)
# code to load and merge the data
loadAndMerge <- function(num) {
  if(num==3) {
    load("oneDf_1.rda")
    data1 <- finalOneDf
    
    load("oneDf_2.rda")
    data2 <- finalOneDf
    
    load("oneDf_3.rda")
    data3 <- finalOneDf
    
    load("oneDf_4.rda")
    data4 <- finalOneDf
    byValue = "fourgram"
  }
  merged1 <- merge(m1,m2, by="onegram", all = TRUE)
  #set all the na as zero
  merged1[is.na(merged1[,2]),2] <- 0
  merged1[is.na(merged1[,3]),3] <- 0
  merged1[,2] <- merged1[,2] + merged1[,3]
  selected <- names(merged1)[1:2]
  merged1 <- merged1[selected]
  names(merged1) <- names(m1)
  m2 <- merged1
  
}
load("threeDf_2.rda")
threed2 <- finalThreeDf
finalOne <- arrange(merged1,desc(Freq))
rm(finalThreeDf)
finalTwo <- finalTwo[finalTwo[,2] >1,]
save(finalTwo, file = "min2.rda")