lin_reg = lm(zillow_count~airbnb_count, data = merged_csv)
summary(lin_reg)
lin_reg

#Code from geeksforgeeks.org
ggplot() + geom_point(aes(x = merged_csv$airbnb_count, y = merged_csv$zillow_count)) +
  geom_line(aes(x =  merged_csv$airbnb_count, y = predict(lin_reg, newdata = merged_csv)))