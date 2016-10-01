library(stringr)
library(dplyr)
print(paste("is minone found", file.exists("./Data/minone.rda")))


if(!exists("finalOne")) {
  print("loading minone.rda")
  load("./Data/min1.rda")
  
}

if(!exists("finalTwo")) {
  print("loading mintwo.rda")
  load("./Data/min2.rda")
}
if(!exists("finalThree")) {
  print("loading min3.rda")
  
  load("./Data/min3.rda")

}

# if(!exists("finalFour")) {
#   print("loading minfour.rda")
#   
#   load("./Data/minfour.rda")
# 
# }
# 
# if(!exists("finalFive")) {
#   print("loading minfive.rda")
#   
#   load("./Data/minfive.rda")
# 
# }

print("all data loaded...")
predict <- function(input, numSuggestion) {
    input <- tolower(input)
    input <- gsub("[[:punct:]]", "", input)
    retVal <- c()
     words <- unlist(str_extract_all(input, "[a-z]+"))
    lw <-length(words)
    if(lw >3) {
      swords <- words[(lw-3):lw]
    } else {
      swords <- words
    }
    len <- length(swords)
    count <- len
    swords <- trimws(swords)
    while(count > 0) {
      
      # if(count > 3) {
      #   #check in five gram
      #   str <- paste(swords[len-3], swords[len-2],swords[len-1],swords[len])
      #   gram <- finalFive
      #   count <- 3 
      #   #print("looking in to five gram")
      #   
      # } else if(count == 3) {
      #   str <- paste(swords[len-2], swords[len-1],swords[len])
      #   gram <- finalFour
      #   count <- 2 
      #   #print("looking in to four gram")
      #   
      #   
      # } else 
        if(count >= 2) {
        str <- paste(swords[len-1], swords[len])
        gram <- finalThree
        count <- 1 
        #print("looking in to three gram")
        
        
      } else if(count == 1) {
        str <- swords[len]
        gram <- finalTwo
        count <- 0 
        #print("looking in to two gram")
        
        
      } 
      str <- paste("^",str,sep="")
      str <- paste(str," ", sep="")
      
      print(paste("looking into ", count+2, "gram for ", str))
      predicted <- predictHelp(gram,str, numSuggestion)
      if(length(predicted) > 0) {
        retVal <- append(retVal, predicted)
      } 
      if(length(retVal) >=numSuggestion) {
        return(retVal[1:numSuggestion])
      }
    }
    if(length(retVal) == 0) {
      retVal <- finalOne[1:numSuggestion,1]
    }
    
   return(retVal)
    
    
}

predictHelp <- function(ngram, searchStr,numSuggestion) {
  res <- grep(searchStr, ngram[,1], value=TRUE)
  if(length(res) >numSuggestion) {
    found <- head(res,numSuggestion)
  } else {
    found <- res
  }
  if(length(found) >0) {
    print(found)
    
  }
  toRet <- trimws(gsub(searchStr, "", found)) 
  # replace the string 
  return(toRet)
  
}

