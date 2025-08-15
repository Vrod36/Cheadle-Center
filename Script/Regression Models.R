install.packages("readr")
instal.packages("ggplot2")
install.packages("dplyr")
install.packages("lubridate")




library(ggplot2)
library(readr)
library(dplyr)
library(lubridate)

# Read the data
data <- read.csv("C:/Users/victo/Downloads/Thermal Tolerance/Regression.csv")

# Convert Duration from H:MM:SS to numeric minutes
data <- data %>% mutate,(Duration_min = period_to_seconds(hms(Duration)) /60
 
                         
# Create CTmin vs Duration plot
ctmin_plot <- ggplot(data, aes(x = Duration_min, y = CTmin)) +
  geom_point(aes(color = `Scientific Name`), alpha = 0.7, size = 3) +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  labs(title = "Relationship Between Duration in Cooler and CTmin",
       x = "Time in Cooler Prior to Assay (minutes)",
       y = "CTmin (°C)",
       color = "Species") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Create CTmax vs Duration plot
ctmax_plot <- ggplot(data, aes(x = Duration_min, y = CTmax)) +
  geom_point(aes(color = `Scientific Name`), alpha = 0.7, size = 3) +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  labs(title = "Relationship Between Duration in Cooler and CTmax",
       x = "Time in Cooler Prior to Assay (minutes)",
       y = "CTmax (°C)",
       color = "Species") +
  theme_minimal() +
  theme(legend.position = "bottom")