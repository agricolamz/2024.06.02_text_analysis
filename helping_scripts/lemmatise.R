library(tidyverse)
library(udpipe)

# load corpus
filepaths <- list.files("./data/plato_w", full.names = TRUE)
corpus <- map(filepaths, readLines)

# load model(download if you need)
udpipe_download_model(language = "russian-syntagrus")
rus_model <- udpipe_load_model("russian-syntagrus-ud-2.5-191206.udpipe")

# annonate corpus
names <- list.files("data/plato_w")
corpus_ann <- map2(corpus, names,
                  udpipe_annotate, 
                  object = rus_model)

corpus_ann_tbl <- map(corpus_ann, as_tibble)

# select lemmas
get_lemma <- function(tbl) {
  tbl |> 
    select(doc_id, lemma)
}

corpus_lemma <- map(corpus_ann_tbl, get_lemma)

# save lemmas
write_lemma <- function(tbl){
  l <- tbl$lemma
  name <- paste0("./data/plato_l/", unique(tbl$doc_id))
  writeLines(l, con = name)
}

map(corpus_lemma, write_lemma)
