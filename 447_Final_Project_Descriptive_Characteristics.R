zillow_csv <- read.csv("zillow.csv")
View(zillow_csv)
head(zillow_csv)


library(dplyr)
library(tidyverse)
library(ggpubr)
library(rio)

# Measures of central tendency
#average housing cost
mean(zillow_csv$price, na.rm = TRUE)

median(zillow_csv$price, na.rm = TRUE)


#median housing cost per zip code

(cost_per_zip_zillow<- zillow_csv %>%
  group_by(zipcode) %>%
  get_summary_stats(price, type="median"))

#mode for number of beds
(mode_beds <- zillow_csv$beds)
(getmode(mode_beds))

#mode for number of bathrooms
(mode_baths <- zillow_csv$baths)
(getmode(mode_baths))

#min housing price
min(zillow_csv$price)

#max housing price
max(zillow_csv$price)




airbnb_csv <- read.csv("airbnb.csv")
View(airbnb_csv)

#average airbnb price
mean(airbnb_csv$price)

#median airbnb price
median(airbnb_csv$price)

#min rental price
min(airbnb_csv$price)

#max rental price
max(airbnb_csv$price)


#average airbnb price per zipcode

(cost_per_zip_airbnb <- airbnb_csv %>%
  group_by(zipcode) %>%
  get_summary_stats(price, type="median"))


