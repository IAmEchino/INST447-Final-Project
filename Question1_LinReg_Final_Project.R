## ==============================
## Airbnb Density vs Housing Price
## Linear Regression
## ==============================

## Load Packages
library(tidyverse)
library(ggpubr)
library(rstatix)

## ------------------------------
## load in dataset
## ------------------------------
merged <- read.csv("merged.csv")

## ------------------------------
## Create Airbnb density groups
## ------------------------------

merged$airbnb_tertile <- cut(merged$airbnb_count,
                             breaks = quantile(merged$airbnb_count, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                             include.lowest = TRUE,
                             labels = c("Low","Medium","High"))
merged

# Summary statistics
merged %>%
  group_by(airbnb_tertile) %>%
  get_summary_stats(zillow_median_price, type="mean_sd")

# Print group sizes
table(merged$airbnb_tertile)

## ------------------------------
## Log Transformation
## ------------------------------

merged <- merged %>%
  mutate(log_price = log(zillow_median_price))

## ------------------------------
## Exploratory visualization
## ------------------------------

# Boxplot: raw prices
ggboxplot(merged,
          x = "airbnb_tertile",
          y = "zillow_median_price",
          ylab = "Median Zillow Housing Price",
          xlab = "Airbnb Density Group") +
  ggtitle("Housing Prices by Airbnb Density Group")

## Boxplot: log-transformed prices
ggboxplot(
  merged,
  x = "airbnb_tertile",
  y = "zillow_median_price",
  xlab = "Airbnb Density Group",
  ylab = "Median Zillow Housing Price (Log Scale)",
  title = "Housing Prices by Airbnb Density Group (Log Scale)"
) +
  scale_y_log10()

## ------------------------------
## Linear Regression assumption checks
## ------------------------------

# Fit regression model
lm_model <- lm(log_price ~ airbnb_count, data = merged)

# Linearity & homoscedasticity
plot(lm_model, which = 1)

# Normality of residuals
ggqqplot(residuals(lm_model),
         title = "Q-Q Plot of Residuals (Linear Regression)")
shapiro_test(residuals(lm_model))

# Influential observations
plot(lm_model, which = 4)  # Cook's distance

## ------------------------------
## Linear Regression
## ------------------------------

lm_model <- lm(log_price ~ airbnb_count, data=merged)

# Model summary
summary(lm_model)

# Confidence intervals
confint(lm_model)

## ------------------------------
## Regression visualization
## ------------------------------
ggplot(merged, aes(x=airbnb_count, y=log_price)) + 
  geom_point() +
  geom_smooth(method = "lm", se= TRUE) + 
  labs(
    title = "Linear Regression: Airbnb Density vs Housing Price",
    x = "Airbnb Density (Count)",
    y = "Log transformed Zillow Median Housing Price"
  )
