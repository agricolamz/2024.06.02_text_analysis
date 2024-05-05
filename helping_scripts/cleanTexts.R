library(tidyverse)

filenames <- list.files("data/plato_w", full.names = TRUE)
filenames

corpus <- map(filenames, readLines)

# функция для уборки
clean_text <- function(text){
  text |> 
    str_c(collapse = " ") |>  
    str_remove("Перевод .+") |> 
    str_remove_all("[\u0041-\u007F]") |> 
    str_remove_all("[0-9]") |> 
    str_remove_all("[[\u0370-\u03FF][\U1F00-\U1FFF]]") |> 
    str_squish()
} 

corpus_clean <- map(corpus, clean_text)

# save files
map2(corpus_clean, filenames, writeLines)
