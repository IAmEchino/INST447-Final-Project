## Load Packages
library(tidyverse)
library(ggpubr)
library(rstatix)

## load in dataset
merged <- read.csv("merged.csv")

## ------------------------------
## Test 1: One way ANOVA
## Independent variable: Airbnb density; 3 conditions - low, medium, high density
## Dependent variable: Housing Price
## ------------------------------

## Assumptions:
## - Independence (ZIP codes)
## - Approximate normality of residuals
## - Homogeneity of variance
## - No significant outliers

# 1) Create density groups
merged$airbnb_tertile <- cut(merged$airbnb_count,
                         breaks = quantile(merged$airbnb_count, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                         include.lowest = TRUE,
                         labels = c("Low","Medium","High"))
merged

## Summary statistics
merged %>%
  group_by(airbnb_tertile) %>%
  get_summary_stats(zillow_median_price, type="mean_sd")

# Print group sizes
table(merged$airbnb_tertile)

## 2) Visualize raw prices
ggboxplot(merged,
          x = "airbnb_tertile",
          y = "zillow_median_price",
          ylab = "Median Zillow Housing Price",
          xlab = "Airbnb Density Group") +
  ggtitle("Housing Prices by Airbnb Density Group")

## Log-scale visualizaion
ggboxplot(
  merged,
  x = "airbnb_tertile",
  y = "zillow_median_price",
  xlab = "Airbnb Density Group",
  ylab = "Median Zillow Housing Price (Log Scale)",
  title = "Housing Prices by Airbnb Density Group (Log Scale)"
) +
  scale_y_log10()

## 3) check outliers
merged %>%
  group_by(airbnb_tertile) %>%
  identify_outliers(zillow_median_price)

# one outlier in medium group (20007)
# one outlier in high group (20019)

## ------------------------------
## Log Transformation
## ------------------------------
merged <- merged %>%
  mutate(log_price = log(zillow_median_price))

## 4) Check assumptions on log-transformed prices

## Normality of residuals
log_model <- lm(log_price ~ airbnb_tertile, data = merged)
ggqqplot(residuals(log_model), title = "Q-Q Plot of Residuals (Log Prices)")
shapiro_test(residuals(log_model))

## Homogeneity of variance
merged %>%
  levene_test(log_price ~ airbnb_tertile)

## ------------------------------
## 5) One-way ANOVA (log prices)
## ------------------------------
log_aov <- merged %>%
  anova_test(log_price ~ airbnb_tertile)

get_anova_table(log_aov)
