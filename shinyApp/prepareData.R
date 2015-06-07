#devtools::install_github('rstudio/DT')

library(readr)
library(magrittr)
library(stringi)
library(dplyr)




file_exists = function(file, url)
{
  if(!file.exists(file))
  {
    url = paste0(url,file)
    message(sprintf("%s nie znaleziono - zostanie pobrane z %s", file, url))
    download.file(url, file)
  }
}

url = "http://files.grouplens.org/datasets/movielens/ml-100k/"
file_exists("u.data", url)
file_exists("u.item", url)

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



