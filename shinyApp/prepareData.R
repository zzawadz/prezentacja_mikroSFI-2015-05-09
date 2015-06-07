#devtools::install_github('rstudio/DT')

library(readr)
library(magrittr)
library(stringi)
library(dplyr)



dataRaw = read_tsv("u.data", col_names = FALSE)
colnames(dataRaw) = c("User","Movie", "Rating", "Timestamp")


# te dane sa bardziej zlosliwe i trzeba wiecej wysilku by je wczytac...
movieInfo = read_lines("u.item")
movieInfo = stri_split_fixed(movieInfo, pattern = "|", simplify = TRUE)
movieInfo = movieInfo[,c(1,2)]
movieInfo = data_frame(Movie = as.numeric(movieInfo[,1]), MovieName = movieInfo[,2])
movieData = merge(dataRaw, movieInfo) %>% as_data_frame

movieData$Movie = movieData$Movie - 1
movieData$User = movieData$User - 1

trainData = rbind(movieData$User, movieData$Movie, movieData$Rating)

movieInfo = data_frame(Movie = movieData$Movie, MovieName = movieData$MovieName) %>% unique



