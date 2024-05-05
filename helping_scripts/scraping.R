library(tidyverse)
library(rvest)
library(xml2)

html <- read_html("https://plato.spbu.ru/TEXTS/Losev.htm")

# this gives us a set of urls
my_urls <- html |>  
  html_elements("tr:nth-child(39) .tLink:nth-child(5) , .minor~ .translator+ .tLink a ,
                .major~ .translator+ .tLink a") |> 
  html_attr("href")


# add prefix
prefix <- "https://plato.spbu.ru/TEXTS/" 
my_urls <- str_c(prefix, my_urls)

# delete NAs
my_urls <- my_urls[!is.na(my_urls)]

my_urls

# grab titles
get_title <- function(x) {
  message("Getting url ",x)
  Sys.sleep(3)
  read_html(x) |> 
    html_element("h2") |> 
    html_text2()
}


titles <- map(my_urls, get_title)
titles

# grab texts
get_text <- function(x) {
  message("Getting url ",x)
  Sys.sleep(3)
  p <- read_html(x) |> 
    html_elements("p") 
  b <- p |> 
    html_elements("b")
  i <- p |> 
    html_elements("i")
  xml_remove(b)
  xml_remove(i)
  p |> 
    html_text2()
}

texts <- map(my_urls, get_text)
texts[[10]]

filenames <- paste0("./data/plato_w/", unlist(titles), ".txt")

map2(texts, filenames, writeLines)
