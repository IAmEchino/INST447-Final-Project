merged <- read.csv("/Users/jincynjenga/Desktop/INST447/merged.csv")

#Assumptions check
#regression model
lin_reg = lm(zillow_count~airbnb_count, data = merged)


# Linearity & homoscedasticity
plot(lin_reg, which = 1)

# Q-Q plot and Shapiro test for normality
ggqqplot(residuals(lin_reg),
         title = "Q-Q Plot of Residuals (Linear Regression)")
shapiro_test(residuals(lin_reg))



#Code to find cooks distance and most influential values: https://towardsdatascience.com/identifying-outliers-in-linear-regression-cooks-distance-9e212e9136a/
cooksD <- cooks.distance(lin_reg)
influential <- cooksD[(cooksD > (3 * mean(cooksD, na.rm = TRUE)))]
#observation 2 and 3 are influential
influential

#removing influential values
merged<- merged[-c(2:3),]


#Code from geeksforgeeks.org
ggplot() + geom_point(aes(x = merged_csv$airbnb_count, y = merged_csv$zillow_count)) +
  geom_line(aes(x =  merged_csv$airbnb_count, y = predict(lin_reg, newdata = merged_csv)))

summary(lin_reg)

