merged_csv <- read.csv("/Users/jincynjenga/Desktop/INST447/merged.csv")

# splitting airbnb_count into low,medium, and high density

library(stats)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(datarium)

merged <- read.csv("/Users/jincynjenga/Desktop/INST447/merged.csv")


merged$airbnb_tertile <- cut(merged$airbnb_count,
                             breaks = quantile(merged$airbnb_count, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                             include.lowest = TRUE,
                             labels = c("Low","Medium","High"))
view(merged)

# the sample_n_by() function randomly select one row of data from each group
merged %>% sample_n_by(airbnb_tertile,size = 1)

#low, medium, and high
levels(merged$airbnb_tertile)


#summary statistics
merged%>%
  group_by(airbnb_tertile) %>%
  get_summary_stats(zillow_count, type="mean_sd")
# low airbnb density --> average zillow count: 51 
# medium airbnb density --> average zillow count per zipcode: 84
# high airbnb density --> average zillow count per zipcode: 196

#zip codes with more airbnbs have more housing availability on zillow 


# visualization using box plot
ggboxplot(merged,x="airbnb_tertile",y="zillow_count")
# neighborhoods with lower airbnb density have a lower median zillow count and one outlier


## check for outliers
outliers <- merged %>%
  group_by(airbnb_tertile) %>%
  identify_outliers(zillow_count)

#there are outliers, but it is not extreme
print(outliers$is.outlier)
print(outliers$is.extreme)

# checking the normality assumption
model <- lm(zillow_count ~airbnb_tertile, data = merged)
#points are falling along the reference line, indicating normality
#qq-plot
ggqqplot(residuals(model))


# use the Shapiro Wilk test of normality 
shapiro_test(residuals(model))
#the p-value is 0.438 (not significant), confirming the data is  normal


#homogeneity of variance assumption
merged %>%
  levene_test(zillow_count ~ airbnb_tertile)
#the p value of the Levene's test is non significant,confirming homogeneity
# of variance


# We are finally ready to compute the ANOVA
pg.aov <- merged %>% anova_test(zillow_count ~ airbnb_tertile)
pg.aov

#p-value is 0.000744<0.05, and F-value is 11.036
#so there is  a significant difference between the density groups

#post-hoc test
pg.pwc <- merged %>% tukey_hsd(zillow_count ~ airbnb_tertile)
pg.pwc
#**need to double check bht there is a significant difference between low and high groups 
#and medium and high groups









