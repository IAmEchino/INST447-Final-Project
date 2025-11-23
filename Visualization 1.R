merged_data <- read.csv("merged.csv")

View(merged_data)

zillow_data <- read.csv("zillow.csv")

View(zillow_data)

plot(merged_data$airbnb_median_price, merged_data$zillow_median_price)

plot(
  merged_data$airbnb_count,
  merged_data$zillow_median_price,
  main = "Airbnb Density vs Housing Cost",
  xlab = "Airbnb Count (Listings per ZIP Code)",
  ylab = "Zillow Listing Price (Median Price per ZIP Code)",
  pch = 19,
  col = "blue"
)

model <- lm(zillow_median_price ~ airbnb_count, data = merged_data)
abline(model, col = "red", lwd = 2)