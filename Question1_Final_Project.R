## Load Packages
library(tidyverse)
library(ggpubr)
library(rstatix)
library(datarium)

## load in dataset
merged <- read.csv("merged.csv")

## Test 1: One way ANOVA
## Independent variable - Airbnb density; 3 conditions - low, medium, high density
## Dependent variable - Housing Price

## Assumptions
## Independence 
## No significant outliers
## Normality
## Homogeneity of variance

# 1) create density groups
merged$airbnb_tertile <- cut(merged$airbnb_count,
                         breaks = quantile(merged$airbnb_count, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                         include.lowest = TRUE,
                         labels = c("Low","Medium","High"))
merged
                         
merged %>%
  group_by(airbnb_tertile) %>%
  get_summary_stats(zillow_median_price, type="mean_sd")

## create boxplot
ggboxplot(merged,x="airbnb_tertile",y="zillow_median_price")

## check outliers
merged %>%
  group_by(airbnb_tertile) %>%
  identify_outliers(zillow_median_price)

## check normality
model <- lm(zillow_median_price ~airbnb_tertile, data = merged)
ggqqplot(residuals(model))

## shapiro wilks test
shapiro_test(residuals(model))

merged %>%
  levene_test(zillow_median_price ~ airbnb_tertile)

## compute the test
pg.aov <- merged %>% anova_test(zillow_median_price ~ airbnb_tertile)
pg.aov




## Test 2: Linear Regression 