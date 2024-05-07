frequency_range <- 1000

corpus_w$word |>
  str_c(collapse = " ") |> 
  tibble(text = _) |> 
  unnest_tokens(output = "bigram", input = text, token = "ngrams", n = 2) |> 
  na.omit() |> 
  separate(bigram, into = c("word1", "word2"), sep = " ") |> 
  anti_join(tibble(word1 = stopwords_ru)) |> 
  anti_join(tibble(word2 = stopwords_ru)) |>
  count(word1, word2) |> 
  slice_max(n = frequency_range, n) ->
  bigram_count

# create unigram count  ---------------------------------------------------

corpus_w |> 
  count(word) |> 
  mutate(total = sum(n))->
  word_count

# merge them all and calculate measures -----------------------------------

bigram_count |> 
  rename(O11 = n) |> 
  left_join(word_count |> select(-total), by = c("word1" = "word")) |> 
  rename(O12 = n) |> 
  left_join(word_count, by = c("word2" = "word")) |> 
  rename(O21 = n) |> 
  mutate(O21 = as.double(O21),
         O12 = as.double(O12),
         O11 = as.double(O11),
         O21 = O21 - O11,
         O12 = O12 - O11,
         O22 = total - O12 - O21 - O11,
         R1 = O11 + O12, 
         R2 = O21 + O22,
         C1 = O11 + O21, 
         C2 = O12 + O22,
         N = O11 + O12 + O21 + O22,
         E11 = R1 * C1 / N, 
         E12 = R1 * C2 / N,
         E21 = R2 * C1 / N, 
         E22 = R2 * C2 / N,
         MI = log2(O11 / E11),
         t.score = (O11 - E11) / sqrt(O11),
         X2 = (O11-E11)^2/E11 + (O12-E12)^2/E12 + (O21-E21)^2/E21 + (O22-E22)^2/E22,
         DP = O11 / R1 - O21 / R2) |> 
  arrange(desc(t.score)) |> 
  select(word1, word2, O11, O21, O12, N, MI, t.score, X2, DP) |> 
  rename(total = N,
         co_occurrence_frequency = O11,
         w1_frequency = O12,
         w2_frequency = O21)
