install.packages("ggplot2")
install



library(ggplot2)
library(dplyr)
library(broom)
library(MASS)


################Scatter Plot BOMBUS#############
bombus_data <- clean_data %>% 
  filter(`Scientific.Name` == "Bombus")  # Or use grepl("Bombus", `Scientific Name`) to catch all Bombus species

bombus_lm <- lm(CTmin ~ Elevation, data = bombus_data)
r2 <- round(summary(bombus_lm)$r.squared, 2)
p_value <- ifelse(summary(bombus_lm)$coefficients[2,4] < 0.001, 
                  "p < 0.001", 
                  paste("p =", round(summary(bombus_lm)$coefficients[2,4], 3)))

ggplot(bombus_data, aes(x = Elevation, y = CTmin)) +
  # Points with legend
  geom_point(
    aes(color = "Bombus CTmin"),  # This creates the legend entry
    size = 4, 
    alpha = 0.7
  ) +
  # Regression line
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  # Color mapping must match the label in aes()
  scale_color_manual(
    name = NULL,
    values = c("Bombus CTmin" = "#E69F00")  # Changed to match label
  ) +
  # Statistics annotation
  annotate("text", 
           x = max(bombus_data$Elevation)*0.94, 
           y = max(bombus_data$CTmin)*0.95,
           label = paste("R² =", r2, "\n", p_value),
           hjust = 0, size = 5) +
  labs(
    x = "Elevation (feet)", 
    y = "CTmin (°C)", 
    title = "CTmin vs Bombus (Sierras 2025)",
    caption = paste("n =", nrow(bombus_data), "Bombus specimens")
  ) +
  theme_bw() +
  theme(
    legend.position = c(0.83, 0.96),
    legend.background = element_rect(fill = "white", color = "black"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(fill = NA, color = "gray50")
  )