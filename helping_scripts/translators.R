library(tidyverse)

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

list.files(path = "data/texts_raw", full.names = TRUE) |> 
  stringi::stri_trans_general(trans_rules, rules=TRUE) |> 
  tolower() |> 
  str_replace_all(" ", "_") |> 
  str_replace_all("\\._", "_") |>
  str_remove_all("_khiga") |> 
  file.rename(from = list.files(path = "data/texts_raw", full.names = TRUE),
              to = _)

filenames <- list.files("data/texts_raw", full.names = T)
filenames

corpus <- map(filenames, read_lines)


get_translator <- function(vec) {
  extracted <- str_extract(vec, "Перевод \\w\\. ?\\w\\..+\\.") 
  ind <- which(!is.na(extracted))
  unique(extracted[ind])[1]
}

translators <- map_chr(corpus, get_translator) |> 
  str_remove("Перевод") |> 
  str_remove("\\.$") |> 
  str_replace_all("Егунова", "Егунов") |> 
  str_replace_all("Соловьева", "Соловьев") |> 
  str_replace_all("Маркиша", "Маркиш") |> 
  str_replace_all("Болдырева", "Болдырев") |> 
  str_replace_all("Аверинцева", "Аверинцев") |> 
  str_replace_all("Васильевой", "Васильева") |> 
  str_replace_all("Томасова", "Томасов") |> 
  str_replace_all("Самсонова", "Самсонов")
# write.table(translators, "translators.txt",
#             col.names = FALSE, quote = FALSE,
#             row.names = FALSE)

trans <- readLines("translators.txt") |> 
  str_squish()
trans

filenames <- list.files("data/texts_raw") |> 
  str_remove("\\.txt") 

translators <- tibble(doc_id = str_replace(filenames, "_", " "), 
                      translator = trans)
write_delim(translators, "translators.csv", delim = ",")

