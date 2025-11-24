library(ggplot2)

merged_data <- read.csv("merged.csv")

histogram <- ggplot(merged_data, aes(x = population)) +
  geom_histogram(
    bins = 10,
    fill = "skyblue",
    color = "black",
    alpha = 0.8
  ) +
  labs(
    title = "Distribution of Population Across ZIP Codes",
    x = "Population (ZIP Code)",
    y = "Number of ZIP Codes"
  ) +
  theme_minimal(base_size = 12)

ggsave(
  filename = "Question 2 Histogram.png",
  plot = histogram,
  width = 8,
  height = 6,
  units = "in"
)

# Buckets appear to show this trend: 0-20,000 is 8 ZIP codes; 20k-40k is 7 zips;
# and 40k-80k is 6 zip codes