# Read in the data
merged_data <- read.csv("merged.csv")

# 1. Determine the maximum Airbnb count in your data
max_count <- max(merged_data$airbnb_count)

# 2. Create a sequence for the breaks
# This sequence starts at 0, goes up to the next multiple of 100
# that is greater than or equal to the max_count, in steps of 100.
custom_breaks <- seq(
    from = 0,
    to = ceiling(max_count / 100) * 100,
    by = 100
)

# 3. Pass the custom_breaks sequence to the 'breaks' argument
hist(
  merged_data$airbnb_count,
  main = "Distribution of Airbnb Density Across ZIP Codes",
  xlab = "Airbnb Count (Listings per ZIP Code)",
  ylab = "Number of ZIP Codes",
  col = "lightblue",
  border = "black",
  breaks = custom_breaks # This line specifies the bin boundaries
)