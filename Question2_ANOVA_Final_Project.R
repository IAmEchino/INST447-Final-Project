## Load Packages
library(tidyverse)
library(ggpubr)
library(rstatix)

## Load dataset
merged <- read.csv("merged.csv")

## ------------------------------
## Test 1: One way ANOVA (Question 2)
## Independent variable: Housing availability (Zillow listing count); 3 conditions - low, medium, high
## Dependent variable: Airbnb Median Price
## ------------------------------

# 1) Create availability groups (tertiles)
merged$availability_tertile <- cut(
  merged$zillow_count,
  breaks = quantile(merged$zillow_count, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
  include.lowest = TRUE,
  labels = c("Low", "Medium", "High")
)

## Summary statistics (mean & sd of Airbnb price by group)
merged %>%
  group_by(availability_tertile) %>%
  get_summary_stats(airbnb_median_price, type = "mean_sd")

## Print group sizes
table(merged$availability_tertile)

## 2) Visualize raw Airbnb prices (boxplot)
ggboxplot(
  merged,
  x = "availability_tertile",
  y = "airbnb_median_price",
  ylab = "Airbnb Median Price (USD)",
  xlab = "Housing Availability Group (Zillow Count)"
) +
  ggtitle("Airbnb Median Prices by Housing Availability Group")

## 3) Check outliers
merged %>%
  group_by(availability_tertile) %>%
  identify_outliers(airbnb_median_price)

## ------------------------------
## Log Transformation (if needed)
## ------------------------------
merged <- merged %>%
  mutate(log_airbnb_price = log(airbnb_median_price))

## 4) Check assumptions on log-transformed prices

## Normality of residuals
log_model <- lm(log_airbnb_price ~ availability_tertile, data = merged)
ggqqplot(residuals(log_model), title = "Q-Q Plot of Residuals (Log Airbnb Prices)")
shapiro_test(residuals(log_model))

## Homogeneity of variance
merged %>%
  levene_test(log_airbnb_price ~ availability_tertile)

## ------------------------------
## 5) One-way ANOVA (log prices)
## ------------------------------
log_aov <- merged %>%
  anova_test(log_airbnb_price ~ availability_tertile)

get_anova_table(log_aov)
