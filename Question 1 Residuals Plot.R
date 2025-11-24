library(ggplot2)

# Load the data
merged_data <- read.csv("merged.csv")

# 1. Fit the linear model
model <- lm(zillow_median_price ~ airbnb_count, data = merged_data)

# 2. Extract residuals and fitted values, and combine them into a dataframe
plot_data <- data.frame(
  Fitted_Price = fitted(model),
  Residuals = resid(model)
)

# ===============================================================
# 3. Create the Residuals Plot using ggplot2
# ===============================================================
residual_plot_ggplot <- ggplot(plot_data, aes(x = Fitted_Price, y = Residuals)) +
  
  # Scatterplot (replicates pch=19, col="darkgreen")
  geom_point(color = "darkgreen", size = 3, alpha = 0.7) +
  
  # Add the horizontal line at 0 (replicates abline(h=0))
  geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 1) +
  
  # Titles and Labels
  labs(
    title = "Residuals Plot of Housing Price vs. Fitted Price",
    x = "Fitted Zillow Median Price (USD)",
    y = "Residuals (Actual - Fitted Price)"
  ) +
  
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.title = element_text(size = 12),
    panel.grid.minor = element_blank()
  )

# 4. Save the plot using ggsave (This will now work correctly!)
ggsave("Question 1 Residuals.png", 
       plot = residual_plot_ggplot, 
       width = 8, 
       height = 6, 
       units = "in", 
       dpi = 300)