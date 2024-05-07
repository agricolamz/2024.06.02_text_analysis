
corpus <- list.files("data/plato_l", full.names = TRUE) |> 
  map_chr(read_lines) |> 
  tibble(doc_id = list.files("data/plato_l"),
         text = _,) |> 
  mutate(text = str_replace_all(text, "невеждый", "невежда"),
         text = str_replace_all(text, "простот", "простота"))

for(i in 1:nrow(corpus)) { 
  text <-corpus[i,]$text
  name <- paste0("./data/plato_l/", corpus[i,]$doc_id)
  writeLines(text, con = name)
  }