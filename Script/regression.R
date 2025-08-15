install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("MASS")
install.packages("janitor")
install.packages("dplyr")
install.packages("ggforce")

library(tidyverse)
library(lubridate)
library(ggplot2)
library(MASS)
library(janitor)
library(dplyr)
library(ggforce)


data <- read.csv("C:/Users/victo/Downloads/Thermal Tolerance/Regression.csv") %>%
  clean_names() %>%
  mutate(
    scientific_name = str_trim(scientific_name),
    scientific_name = str_replace(scientific_name, "\\s+", " "),
    duration_min = period_to_seconds(hms(duration)) / 60
  ) %>%
  filter(duration < 4) %>%
  # Filter out the unwanted species
  filter(!scientific_name %in% c("Hylaeus", "Parasite bee?", "Osmia", "Andrena"))

data <- data %>%
  mutate(
    duration_min = period_to_seconds(hms(`duration`)) / 60
    )


unique(data$scientific_name)
names(data)


str(data)
##########CTMIN################
# Filter and create CTmin plot
c_tmin_data <- data %>% filter(!is.na(c_tmin))

ggplot(c_tmin_data, aes(x = duration_min, y = c_tmin)) +
  geom_point(aes(color = scientific_name), size = 3, alpha = 0.9) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(title = "CTmin vs Time in Cooler Prior to Assay",
       x = "Time in Cooler (minutes)",
       y = "CTmin (°C)",
       color = "Species") +
  theme_bw() +
  theme(legend.position = "top") +
  scale_color_viridis_d() # Optional: better color palette

##################JUST BOMBUS###########
bombus_data_max <- read.csv("C:/Users/victo/Downloads/Thermal Tolerance/Regression.csv") %>%
  janitor::clean_names() %>%
  mutate(
    duration_min = period_to_seconds(hms(duration)) / 60,
    scientific_name = str_trim(scientific_name)
  ) %>%
  filter(str_detect(scientific_name, "Bombus")) %>%
  filter(duration < 4) %>%# Keep only Bombus
  filter(!is.na(duration_min)) # Remove any rows with missing duration

####CTMIN BOMBUS####
bombus_ctmax <- bombus_data_max %>% filter(!is.na(c_tmax)) %>% 
  mutate(
    density = approxfun(density(duration_min))(duration_min),
    alpha_val = scales::rescale(density, to = c(0.3, 1)) # Scale opacity
  )

ggplot(bombus_ctmax, aes(x = duration_min, y = c_tmax)) +
  geom_point(size = 3, color = "#56B4E9", alpha = 0.8) +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  scale_x_continuous(
    breaks = seq(60, 360, by = 45),
    labels = function(x) {
      hours <- floor(x/60)
      mins <- x %% 60
      ifelse(mins == 0, 
             paste0(hours, "h"), 
             paste0(hours, "h", mins, "m"))
    },
    name = "Time in Cooler",
    limits = c(45, max(bombus_ctmax$duration_min, na.rm = TRUE) * 1.05)
  ) +
  labs(
    title = "Bombus CTmin vs Cooling Duration",
    subtitle = "X-axis starts at 45 minutes with 45-minute intervals",
    y = "CTmin (°C)"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

#######################
bombus_ctmax_new <- bombus_data_max %>% filter(!is.na(c_tmax)) %>% 
  mutate(
    duration_bin = cut(duration_min, breaks = seq(0, 360, by = 15)),
    density = approxfun(density(duration_min))(duration_min),
    alpha_val = scales::rescale(density, to = c(0.3, 1)) # Scale opacity
  )


lm_model <- lm(c_tmax ~ duration_min, data = bombus_ctmax_new)
lm_summary <- summary(lm_model)
p_value <- format.pval(lm_summary$coefficients[2,4], digits = 3, eps = 0.001)



# Create the plot
ggplot(bombus_ctmax_new, aes(x = duration_min, y = c_tmax)) +
  # Use regular points with density-based opacity
  geom_point(
    aes(alpha = alpha_val), 
    size = 3, 
    color = "#56B4E9",
    position = position_jitter(width = 2) # Small jitter to reduce overlap
  ) +
  # Add smoothed trend line
  geom_smooth(
    method = "lm", 
    se = TRUE, 
    color = "black",
    fill = "gray80"
  ) +
  annotate(
    "text",
    x = max(bombus_ctmax_new$duration_min) * 0.9,  # Position on right side
    y = max(bombus_ctmax_new$c_tmax) * 0.9,       # Position near top
    label = paste0("p = ", p_value),
    size = 4,
    color = "black",
    fontface = "italic"
  ) +
  # Custom x-axis with 45-minute intervals starting at 45
  scale_x_continuous(
    breaks = seq(45, 360, by = 45),
    labels = function(x) {
      hours <- floor(x/60)
      mins <- x %% 60
      ifelse(mins == 0, paste0(hours, "h"), paste0(hours, "h", mins, "m"))
    },
    name = "Time in Cooler (Duration)",
    limits = c(45, max(bombus_ctmax_new$duration_min, na.rm = TRUE) * 1.05)
  ) +
  scale_alpha_continuous(
    name = "Bombus Abundance",
    breaks = c(0.3, 0.6, 0.9),
    labels = c("Low", "Medium", "High"),
    guide = guide_legend(
      override.aes = list(size = 2), # Smaller points in legend
      keywidth = unit(4, "mm"),     # Narrower legend keys
      keyheight = unit(4, "mm"),    # Shorter legend keys
      title.position = "top",
      title.hjust = 0.5,
      label.position = "right",
      label.hjust = 0
    )
  ) +
  # Labels and titles
  labs(
    title = "Bombus CTmax vs Duration in Vials",
    y = "Critical Thermal Maximum (°C)"
  ) +
  # Theme adjustments
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = c(0.85,0.9),
    legend.title = element_text(size = 9),  # Smaller legend title
    legend.text = element_text(size = 8),   # Smaller legend text
    legend.spacing.y = unit(2, "mm"),      # Reduced spacing between legend items
    legend.margin = margin(0, 0, 0, 0),    # Tighten legend margins
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.caption = element_text(hjust = 0, face = "italic")
  ) +
  geom_vline(xintercept = 45, linetype = "dashed", color = "gray50", alpha = 0.5)