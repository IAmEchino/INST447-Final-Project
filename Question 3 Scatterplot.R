library(ggplot2)

merged_data <- read.csv("merged.csv")

# --- Calculations for Regression Equation and R-squared ---
# Model: Zillow Count ~ Airbnb Count
model <- lm(zillow_count ~ airbnb_count, data = merged_data)
model_summary <- summary(model)
r_squared <- model_summary$r.squared
intercept <- coef(model)[1]
slope <- coef(model)[2]

# Format the equation string (using the corrected method with as.expression())
equation_label <- as.expression(bquote(
    italic(y) == .(format(slope, digits = 3)) * italic(x) + .(format(intercept, digits = 3)) *
    " ," ~ R^2 == .(format(r_squared, digits = 3))
))

# --- Create the ggplot Scatterplot ---
scatterplot <- ggplot(merged_data, aes(x = airbnb_count, y = zillow_count)) +
  # Add points
  geom_point(color = "blue", size = 2) +
  # Add regression line
  geom_smooth(
    method = "lm",
    # se = FALSE,
    color = "red",
    linewidth = 1
  ) +
  # Set titles and labels
  labs(
    title = "Airbnb Density vs Housing Availability",
    x = "Airbnb Count (Listings per ZIP Code)",
    y = "Zillow Listing Count (Listings per ZIP Code)"
  ) +
  # Add the equation and R-squared text
  annotate(
    "text",
    x = max(merged_data$airbnb_count, na.rm = TRUE),
    y = max(merged_data$zillow_count, na.rm = TRUE),
    label = equation_label,
    parse = TRUE,
    hjust = 1.05,
    vjust = 1.5,
    size = 4
  ) +
  theme_minimal()

# Save the plot
ggsave(
  filename = "Question 3 Scatterplot.png",
  plot = scatterplot,
  width = 8,
  height = 6,
  units = "in"
)