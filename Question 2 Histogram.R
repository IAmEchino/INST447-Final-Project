library(ggplot2)

# Load the data
merged_data <- read.csv("merged.csv")

# ===============================================================
# Histogram of Population Distribution with Binwidth = 10,000
# ===============================================================
histogram <- ggplot(merged_data, aes(x = population)) +
  
  # FIX: Set boundary = 0 to align bin edges with tick breaks
  geom_histogram(
    binwidth = 10000, 
    boundary = 0, # <-- This aligns the bin edges with the tick marks
    fill = "skyblue",
    color = "black",
    alpha = 0.8
  ) +
  
  # Ensure breaks are at multiples of 10,000
  scale_x_continuous(
    breaks = seq(0, 80000, by = 10000), 
    labels = scales::comma 
  ) +
  
  labs(
    title = "Distribution of Population Across ZIP Codes",
    x = "Population (ZIP Code)",
    y = "Number of ZIP Codes"
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.title = element_text(size = 12)
  )

# Save the plot
ggsave(
  filename = "Question 2 Histogram.png",
  plot = histogram,
  width = 8,
  height = 6,
  units = "in"
)

# Buckets appear to show this trend: 0-20,000 is 8 ZIP codes; 20k-40k is 7 zips;
# and 40k-80k is 6 zip codes