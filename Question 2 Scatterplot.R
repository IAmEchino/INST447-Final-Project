library(ggplot2)

# Load data
merged_data <- read.csv("merged.csv")

# --- Calculations for Regression Equation and R-squared ---

# 1. Calculate the Linear Model
modelQ2 <- lm(airbnb_median_price ~ population, data = merged_data)

# 2. Extract R-squared and Coefficients
model_summary <- summary(modelQ2)
r_squared <- model_summary$r.squared
intercept <- coef(modelQ2)[1]
slope <- coef(modelQ2)[2]

# 3. FIXED: Format the equation string using bquote and wrap in as.expression()
equation_label <- as.expression(bquote(
    italic(y) == .(format(slope, digits = 3)) * italic(x) + .(format(intercept, digits = 3)) *
    " ," ~ R^2 == .(format(r_squared, digits = 3))
))

# --- Create the ggplot Scatterplot ---

scatterplot <- ggplot(merged_data, aes(x = population, y = airbnb_median_price)) +
  # Add points
  geom_point(color = "purple", size = 2) +
  # Add regression line (method="lm", no standard error ribbon)
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = "red",
    linewidth = 1
  ) +
  # Set titles and labels
  labs(
    title = "Airbnb Rental Price vs Population (ZIP Code Level)",
    x = "Population (ZIP Code)",
    y = "Airbnb Median Price (USD)"
  ) +
  # Add the equation and R-squared text
  annotate(
    "text",
    x = max(merged_data$population, na.rm = TRUE),
    y = max(merged_data$airbnb_median_price, na.rm = TRUE),
    label = equation_label,
    parse = TRUE,
    hjust = 1.05,
    vjust = 1.5,
    size = 4
  ) +
  theme_minimal()

# --- Save the plot ---

ggsave(
  filename = "Question 2 Linear Scatterplot.png",
  plot = scatterplot,
  width = 8,
  height = 6,
  units = "in"
)

library(ggplot2)

# Load data
merged_data <- read.csv("merged.csv")

# 1. Create a new variable: Log of Population
# We use log() which, by default, is the natural logarithm (ln)
merged_data$log_population <- log(merged_data$population)

# --- Calculations for Regression Equation and R-squared (Log-Linear Model) ---

# 2. Calculate the Log-Linear Model
modelQ_log <- lm(airbnb_median_price ~ log_population, data = merged_data)

# 3. Extract R-squared and Coefficients
model_summary_log <- summary(modelQ_log)
r_squared_log <- model_summary_log$r.squared
intercept_log <- coef(modelQ_log)[1]
slope_log <- coef(modelQ_log)[2]

# 4. Format the equation string (y = a + b * log(x))
# We must use as.expression(bquote()) to avoid the previous error
equation_label_log <- as.expression(bquote(
    italic(y) == .(format(slope_log, digits = 3)) * log(italic(x)) + .(format(intercept_log, digits = 3)) *
    " ," ~ R^2 == .(format(r_squared_log, digits = 3))
))

# --- Create the ggplot Scatterplot (Log-Linear) ---

scatterplot_log <- ggplot(merged_data, aes(x = log_population, y = airbnb_median_price)) +
  # Add points
  geom_point(color = "blue", size = 2) +
  # Add regression line
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = "red",
    linewidth = 1
  ) +
  # Set titles and labels (note the updated X-axis label)
  labs(
    title = "Airbnb Median Price vs Log(Population)",
    x = "Log(Population) (Natural Logarithm)",
    y = "Airbnb Median Price (USD)"
  ) +
  # Add the equation and R-squared text
  annotate(
    "text",
    x = max(merged_data$log_population, na.rm = TRUE),
    y = max(merged_data$airbnb_median_price, na.rm = TRUE),
    label = equation_label_log,
    parse = TRUE,
    hjust = 1.05,
    vjust = 1.5,
    size = 4
  ) +
  theme_minimal()

# --- Save the plot ---

ggsave(
  filename = "Question 2 Log-Linear Scatterplot.png",
  plot = scatterplot_log,
  width = 8,
  height = 6,
  units = "in"
)