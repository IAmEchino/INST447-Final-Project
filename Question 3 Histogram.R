library(ggplot2)

# Read the data
merged_data <- read.csv("merged.csv")

# Create the histogram plot object
histogram_plot <- ggplot(merged_data, aes(x = airbnb_count)) +
  
  # FIX: Add boundary = 0 to align bin edges with tick breaks
  geom_histogram(
    binwidth = 100,
    boundary = 0, # <-- This aligns the bin edges with the tick marks
    fill = "lightblue",
    color = "black"
  ) +
  
  # Set explicit breaks for clear alignment and readability
  scale_x_continuous(
    breaks = seq(0, 1000, by = 100), 
    labels = scales::comma,
    expand = c(0, 0) # Ensures bars start exactly at 0
  ) +
  
  # Set titles and labels
  labs(
    title = "Distribution of Airbnb Density Across ZIP Codes",
    x = "Airbnb Count (Listings per ZIP Code)",
    y = "Number of ZIP Codes"
  ) +
  
  # Use a clean theme
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.title = element_text(size = 12)
  )

# Save the plot as a PNG file
ggsave(
  filename = "Question 3 Histogram.png",
  plot = histogram_plot,
  width = 8,
  height = 6,
  units = "in"
)