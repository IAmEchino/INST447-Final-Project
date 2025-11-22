plot(
  dataset$airbnb_count,
  dataset$zillow_count,
  main = "Airbnb Density vs Housing Availability",
  xlab = "Airbnb Count (Listings per ZIP Code)",
  ylab = "Zillow Listing Count (Listings per ZIP Code)",
  pch = 19,
  col = "blue"
)

model <- lm(zillow_count ~ airbnb_count, data = dataset)
abline(model, col = "red", lwd = 2)
