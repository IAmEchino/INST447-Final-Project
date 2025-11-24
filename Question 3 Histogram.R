library(ggplot2)

# Read the data
merged_data <- read.csv("merged.csv")

# Create the histogram plot object
histogram_plot <- ggplot(merged_data, aes(x = airbnb_count)) +
  # Set the bin width to 100
  geom_histogram(
    binwidth = 100,
    fill = "lightblue",
    color = "black"
  ) +
  # Set titles and labels
  labs(
    title = "Distribution of Airbnb Density Across ZIP Codes",
    x = "Airbnb Count (Listings per ZIP Code)",
    y = "Number of ZIP Codes"
  ) +
  # Use a clean theme
  theme_minimal()

# Save the plot as a PNG file
ggsave(
  filename = "Question 3 Histogram.png",
  plot = histogram_plot,
  width = 8,
  height = 6,
  units = "in"
)