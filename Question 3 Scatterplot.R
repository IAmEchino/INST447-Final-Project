# Scatterplot Airbnb Density vs Housing Availability

merged_data <- read.csv("merged.csv")

plot(
  merged_data$airbnb_count,
  merged_data$zillow_count,
  main = "Airbnb Density vs Housing Availability",
  xlab = "Airbnb Count (Listings per ZIP Code)",
  ylab = "Zillow Listing Count (Listings per ZIP Code)",
  pch = 19,
  col = "blue"
)

model <- lm(zillow_count ~ airbnb_count, data = merged_data)
abline(model, col = "red", lwd = 2)