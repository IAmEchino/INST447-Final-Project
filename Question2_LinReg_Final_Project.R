## =========================================
## Airbnb Price vs Housing Availability
## Linear Regression (Question 2)
## =========================================

## Load Packages
library(tidyverse)
library(ggpubr)
library(rstatix)

## ------------------------------
## Load in dataset
## ------------------------------
merged <- read.csv("merged.csv")

## ------------------------------
## Create Housing Availability Groups
## ------------------------------

merged$availability_tertile <- cut(
  merged$zillow_count,
  breaks = quantile(merged$zillow_count,
                    probs = c(0, 1/3, 2/3, 1),
                    na.rm = TRUE),
  include.lowest = TRUE,
  labels = c("Low","Medium","High")
)

# Summary statistics
merged %>%
  group_by(availability_tertile) %>%
  get_summary_stats(airbnb_median_price, type = "mean_sd")

# Print group sizes
table(merged$availability_tertile)

## ------------------------------
## Log Transformation
## ------------------------------

merged <- merged %>%
  mutate(log_airbnb_price = log(airbnb_median_price))

## ------------------------------
## Exploratory Visualization
## ------------------------------

# Boxplot: raw prices
ggboxplot(
  merged,
  x = "availability_tertile",
  y = "airbnb_median_price",
  ylab = "Airbnb Median Price (USD)",
  xlab = "Housing Availability Group"
) +
  ggtitle("Airbnb Prices by Housing Availability Group")

# Boxplot: log-transformed prices
ggboxplot(
  merged,
  x = "availability_tertile",
  y = "airbnb_median_price",
  xlab = "Housing Availability Group",
  ylab = "Airbnb Median Price (Log Scale)",
  title = "Airbnb Prices by Housing Availability Group (Log Scale)"
) +
  scale_y_log10()

## ------------------------------
## Linear Regression Assumption Checks
## ------------------------------

# Fit regression model
lm_model <- lm(log_airbnb_price ~ zillow_count, data = merged)

# Linearity & homoscedasticity
plot(lm_model, which = 1)

# Normality of residuals
ggqqplot(
  residuals(lm_model),
  title = "Q-Q Plot of Residuals (Linear Regression)"
)
shapiro_test(residuals(lm_model))

# Influential observations
plot(lm_model, which = 4)  # Cook's distance

## ------------------------------
## Linear Regression
## ------------------------------

lm_model <- lm(log_airbnb_price ~ zillow_count, data = merged)

# Model summary
summary(lm_model)

# Confidence intervals
confint(lm_model)

## ------------------------------
## Regression Visualization
## ------------------------------

ggplot(merged, aes(x = zillow_count, y = log_airbnb_price)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Linear Regression: Housing Availability vs Airbnb Price",
    x = "Zillow Listing Count",
    y = "Log Transformed Airbnb Median Price"
  )
