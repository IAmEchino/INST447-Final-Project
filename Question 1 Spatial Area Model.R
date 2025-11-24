# 1. Load Necessary Libraries
library(spdep)
library(sp)
library(RANN)
library(spatialreg)
library(ggplot2)

# 2. Load the Data
merged_data <- read.csv("merged.csv")

# 3. Create a Spatial Data Frame
# Remove any rows with missing coordinates
merged_data <- na.omit(merged_data)

coordinates(merged_data) <- ~airbnb_avg_longitude + airbnb_avg_latitude
proj4string(merged_data) <- CRS("+proj=longlat +datum=WGS84")

# 4. Define the Spatial Weights Matrix (W-Matrix)
# Using k-nearest neighbors (k=4)
k_neighbors <- knearneigh(merged_data, k=4)
nb_4 <- knn2nb(k_neighbors)

# Convert to a row-standardized weight matrix
listw_4 <- nb2listw(nb_4, style="W")

# 5. Define the Linear Model Formula
formula <- zillow_median_price ~ airbnb_count

# 6. Run the Spatial Error Model (SEM)
# The function call is simplified, removing the 'type' argument.
spatial_error_model <- spatialreg::errorsarlm(
  formula,
  data = merged_data,
  listw = listw_4
)

# 7. Print the Summary
summary(spatial_error_model)

# R Code for Visualization: Map of Residuals

library(ggplot2)
library(sf)

# 1. Convert the 'sp' object to an 'sf' object for ggplot visualization
merged_sf <- st_as_sf(merged_data)

# 2. Add Residuals and Fitted Values (if not done in step A)
if (!("sem_residuals" %in% names(merged_sf))) {
  merged_sf$sem_residuals <- residuals(spatial_error_model)
}

# Create a bubble map where size and color represent the residual value.
spatial_plot <- ggplot(merged_sf) +
  # Use geom_sf for mapping the spatial points
  geom_sf(aes(size = abs(sem_residuals), color = sem_residuals)) +
  scale_color_gradient2(
    low = "#0000FF",       # Over-predicted (negative residual)
    mid = "grey80",
    high = "#FF0000",     # Under-predicted (positive residual)
    midpoint = 0,
    name = "Residuals (USD)"
  ) +
  scale_size(range = c(1, 30), name = "Abs. Residuals") +
  labs(
    title = "Spatial Error Model Residuals: DC ZIP Codes",
    subtitle = "Color/Size indicates the model's prediction error (Actual - Fitted Price)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

ggsave("Question 1 Spatial Area Model.png", 
       plot = spatial_plot,
       width = 8, 
       height = 8,
       units = "in", 
       dpi = 300)

print(spatial_plot)