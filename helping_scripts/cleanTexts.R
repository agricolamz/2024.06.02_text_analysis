library(tidyverse)

names <- list.files("texts_raw")
filenames <- paste0("./texts_raw/", names)

corpus <- map(filenames, readLines)

# функция для уборки
clean_text <- function(text){
  text %>%
    str_c(collapse = " ") %>% 
    str_remove("Перевод .+") %>% 
    str_remove_all("[\u0041-\u007F]") %>% 
    str_remove_all("[0-9]") %>% 
    str_squish()
} 

corpus_clean <- map(corpus, clean_text)

# save files
dir.create("texts_clean")
filenames <- paste0("./texts_clean/", names)
map2(corpus_clean, filenames, writeLines)
