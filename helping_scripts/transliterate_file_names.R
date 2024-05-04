setwd("/home/agricolamz/work/materials/2024.06.02_text_analysis")
library(tidyverse)
list.files(path = "data/plato_w/")

trans_rules <- "
    я > ya;
    Я > Ya;
    ю > yu;    
    Ю > Yu;
    ё > yo;    
    Ё > Yo;
    Э > E;
    э > e;
    Й > Y;
    й > y;
    Ь > ;
    ь > ;
    Ш > Sh;
    ш > sh;
    Щ > shsh;
    щ > shsh;
    Ч > сh;
    ч > сh;
    :: cyrillic-latin;
"

list.files(path = "data/plato_w", full.names = TRUE) |> 
  stringi::stri_trans_general(trans_rules, rules=TRUE) |> 
  tolower() |> 
  str_replace_all(" ", "_") |> 
  str_replace_all("\\._", "_") |>
  str_remove_all("_khiga") |> 
  file.rename(from = list.files(path = "data/plato_w", full.names = TRUE),
              to = _)
  
list.files(path = "data/plato_l", full.names = TRUE) |> 
  stringi::stri_trans_general(trans_rules, rules=TRUE) |> 
  tolower() |> 
  str_replace_all(" ", "_") |> 
  str_replace_all("\\._", "_") |>
  str_remove_all("_khiga") |> 
  file.rename(from = list.files(path = "data/plato_l", full.names = TRUE),
              to = _)
