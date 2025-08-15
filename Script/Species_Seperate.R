install.packages("ggplot2")
install.packages("MASS")



library(ggplot2)
library(dplyr)
library(broom)
library(MASS)

Bombus <- read.csv("C:/Users/victo/Downloads/Thermal Tolerance/Data.csv", header = TRUE)


################Scatter Plot BOMBUS#############
bombus_data <- Bombus %>% 
  filter(grepl("Bombus", Scientific.Name, ignore.case = TRUE))

#######################CTMIN##########################
ggplot( bombus_data, aes(x = Elevation, y = CTmax)) +
  geom_point(
    aes(color = "CTmax Values"), 
    alpha = 0.3, 
    size = 5,
    show.legend = TRUE
  ) +
  geom_smooth(method = "lm", color = "red") +
  scale_color_manual(
    name = NULL,
    values = c("CTmax Values" = "goldenrod1")
  ) +
  # Add the statistics annotation
  annotate("text", 
           x = max(bombus_data$Elevation)*0.95,  # Position in upper right
           y = max(bombus_data$CTmin)*0.93,
           label = paste("R² =", r_squared, "\n", p_value),
           hjust = 0, size = 4) +
  labs(
    x = "Elevation (feet)", 
    y = "Critical Thermal Maximum (°C)", 
    title = "CTmax vs. Elevation (Sierra Nevada Bombus)"
  ) +
  theme_bw() +
  theme(
    legend.position = c(0.836, 0.96),
    legend.background = element_rect(fill = "white", color = "black"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(fill = NA, color = "black")
  )
######################CTMAX##########################
ggplot( bombus_ctmax, aes(x = Elevation, y = CTmax)) +
  geom_point(
    aes(color = "CTmax Values"), 
    alpha = 0.3, 
    size = 5,
    show.legend = TRUE
  ) +
  geom_smooth(method = "lm", color = "red") +
  scale_color_manual(
    name = NULL,
    values = c("CTmax Values" = "goldenrod1")
  ) +
  # Add the statistics annotation
  annotate("text", 
           x = max(bombus_ctmax$Elevation)*0.95,  # Position in upper right
           y = max(bombus_ctmax$CTmax)*0.93,
           label = paste("R² =", r_squared, "\n", p_value),
           hjust = 0, size = 4) +
  labs(
    x = "Elevation (feet)", 
    y = "Critical Thermal Maximum (°C)", 
    title = "CTmax vs. Elevation (Sierra Nevada Bombus)"
  ) +
  theme_bw() +
  theme(
    legend.position = c(0.827, 0.96),
    legend.background = element_rect(fill = "white", color = "black"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(fill = NA, color = "black")
  )
###############################################
# First ensure your data is properly formatted
bombus_ctmax <- bombus_ctmax %>%
  mutate(Elevation = as.numeric(Elevation))  # Ensure numeric

# Create the plot with fixed x-axis breaks
ggplot(bombus_ctmax, aes(x = Elevation, y = CTmax)) +
  geom_point(
    aes(color = "CTmax Values"), 
    alpha = 0.3, 
    size = 5,
    show.legend = TRUE
  ) +
  geom_smooth(method = "lm", color = "red") +
  scale_color_manual(
    name = NULL,
    values = c("CTmax Values" = "goldenrod1")
  ) +
  # Add evenly spaced x-axis breaks
  scale_x_continuous(
    breaks = seq(
      floor(min(bombus_ctmax$Elevation)/1000)*1000,  # Round down to nearest 1000
      ceiling(max(bombus_ctmax$Elevation)/1000)*1000, # Round up to nearest 1000
      by = 1000  # 1000-ft intervals
    )
  ) +
  # Statistics annotation
  annotate("text", 
           x = max(bombus_ctmax$Elevation)*0.95,
           y = max(bombus_ctmax$CTmax)*0.985,
           label = paste("R² =", r_squared, "\n", p_value),
           hjust = 0, size = 4) +
  labs(
    x = "Elevation (feet)", 
    y = "Critical Thermal Maximum (°C)", 
    title = "CTmax vs. Elevation (SN Bombus)"
  ) +
  theme_minimal() +
  theme(
    legend.position = c(0.827, 0.96),
    legend.background = element_rect(fill = "white", color = "black"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90"),  # Add vertical gridlines
    panel.border = element_rect(fill = NA, color = "black")
  )