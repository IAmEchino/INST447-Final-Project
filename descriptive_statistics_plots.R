
zillow_csv <- read.csv("/Users/jincynjenga/Desktop/INST447/zillow.csv")

#coercion - treat zipcode as a categorical variable by changing it into text
zillow_csv$zipcode <-as.character(zillow_csv$zipcode)

zillow_csv %>% 
  ggplot(aes(x = zipcode)) +
  geom_bar() +
  labs(title="Number of Homes per Zipcode (Zillow)", y = "Number of Homes", x = "Zipcode") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


ggplot(data=zillow_csv, mapping=aes(x=zipcode, y=price))+
  geom_boxplot() +
  labs(title="Box Plot of House Prices Per Zipcode (Zillow)", y = "Price", x = "Zipcode")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


airbnb_csv <- read.csv("/Users/jincynjenga/Desktop/INST447/airbnb.csv")
airbnb_csv$zipcode <-as.character(airbnb_csv$zipcode)
airbnb_csv  %>% 
  ggplot(aes(x = zipcode)) +
  geom_bar() +
  labs(title="Number of Homes per Zipcode (Airbnb)", y = "Number of Homes", x = "Zipcode") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

ggplot(data=airbnb_csv, mapping=aes(x=zipcode, y=price))+
  geom_boxplot() +
  ylim(0,500) +
  labs(title="Box Plot of House Prices Per Zipcode (Airbnb)", y = "Price", x = "Zipcode")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
