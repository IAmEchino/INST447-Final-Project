library(ggplot2)

merged_data <- read.csv("merged.csv")

# 1. Create a grouping variable based on the 'population' column
# Breaks define the boundaries (0, 20k, 40k, 80k, and up to infinity)
merged_data$population_group <- cut(
  merged_data$population,
  breaks = c(0, 10000, 20000, 40000, Inf),
  labels = c("0 - 10k", "10k-20k", "20k - 40k", "40k - 80k"),
  include.lowest = TRUE,
  right = TRUE # Intervals are inclusive on the right end
)

# 2. Create the boxplot
boxplot <- ggplot(merged_data, aes(x = population_group, y = airbnb_median_price, fill = population_group)) +
  geom_boxplot(color = "black") +
  labs(
    title = "Airbnb Median Price Distribution by Population Group",
    x = "Population (ZIP Code)",
    y = "Airbnb Median Price (USD)",
    fill = "Population Group"
  ) +
  theme_minimal() +
  theme(legend.position = "none") # Remove redundant legend

# 3. Save the plot
ggsave(
  filename = "Question 2 Boxplots.png",
  plot = boxplot,
  width = 10,
  height = 6,
  units = "in"
)