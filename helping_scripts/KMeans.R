set.seed(02062024)
# установим число центров по числу переводчиков
km_out <- kmeans(corpus_mx, centers = 6, nstart = 20)

tibble(expected = expected, 
       predicted = km_out$cluster) |> 
  group_by(expected) |> 
  count(predicted)


### визуализация кластеров
pca_fit <- prcomp(corpus_mx, scale = F, center = F)

library(broom)
pca_fit |>
  augment(corpus_mx) |> 
  mutate(translator = expected) |> 
  ggplot(aes(.fittedPC1, .fittedPC2, 
             color = expected,
             shape = as.factor(km_out$cluster))) +
  geom_point(size = 3, alpha = 0.7) +
  guides(shape=guide_legend(title="clusters"))

# с фасетизацией

for_plot <- pca_fit |>
  augment(corpus_mx) |> 
  mutate(translator = expected)

library(ggrepel)

for_plot |> 
  ggplot(aes(.fittedPC1, .fittedPC2, color = as.factor(km_out$cluster))) +
  geom_point(size = 1, color = "grey80", 
             data = for_plot |>  select(-translator)) +
  geom_point(size = 1) +
  geom_text_repel(aes(label = corpus_id), max.overlaps = 100)+
  guides(color=guide_legend(title="clusters")) +
  facet_wrap( ~ translator) +
  theme(legend.position = "bottom")

  