# Histogram Distribution of Airbnb Density Across ZIP Codes

merged_data <- read.csv("merged.csv")

hist(
  merged_data$airbnb_count,
  main = "Distribution of Airbnb Density Across ZIP Codes",
  xlab = "Airbnb Count (Listings per ZIP Code)",
  ylab = "Number of ZIP Codes",
  col = "lightblue",
  border = "black"
)