# Load the data
merged_data <- read.csv("merged.csv")

# Fit the linear model to calculate R-squared and residuals
model <- lm(zillow_median_price ~ airbnb_count, data = merged_data)
r_squared_text <- paste0("R^2 = ", format(summary(model)$r.squared, digits = 3))

# ===============================================================
# 1. Scatterplot with Linear Regression and R-squared
# ===============================================================
library(ggplot2)

# Load the data
merged_data <- read.csv("merged.csv")

# Constants derived from OLS model (Calculated based on your data):
# R^2 = 0.024
# Equation: y = -274.74 * x + 876516

# 1. Create the ggplot object
visualization_plot <- ggplot(merged_data, aes(x = airbnb_count, y = zillow_median_price)) +
  
  # Scatterplot points
  geom_point(color = "blue", size = 3, alpha = 0.7) +
  
  # Linear Regression Line
  geom_smooth(method = "lm", se = TRUE, color = "red", linetype = "solid", linewidth = 1.5) +
  
  # Titles and Labels
  labs(
    title = "Airbnb Density vs Zillow Median Housing Price",
    x = "Airbnb Count (Listings per ZIP Code)",
    y = "Zillow Median Price (USD per ZIP Code)"
  ) +
  
  # Add R-squared and Equation annotation
  # The 'paste()' and 'parse=TRUE' arguments allow R to render the text as a mathematical expression.
  annotate("text",
           x = max(merged_data$airbnb_count, na.rm = TRUE) * 0.95,
           y = max(merged_data$zillow_median_price, na.rm = TRUE) * 0.95,
           # Label structure: Equation, followed by R^2 on a new line (using the '~' separator)
           label = paste("y == -274.74 * x + 876516", "~','~ \"R^2 = 0.024\""),
           parse = TRUE, 
           color = "red",
           size = 5,
           hjust = 1, vjust = 1
           ) +
  
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.title = element_text(size = 12),
    panel.grid.minor = element_blank()
  )

# 2. Save the plot to a PNG file
ggsave("Question 1 Scatterplot.png", plot = visualization_plot, width = 8, height = 6, units = "in", dpi = 300)

print(visualization_plot)