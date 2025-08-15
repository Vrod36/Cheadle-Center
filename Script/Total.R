install.packages("ggplot2")
install.packages("dplyr")
install.packages("MASS")

library(ggplot2)
library(dplyr)
library(MASS)

data <- read.csv("C:/Users/victo/Downloads/Thermal Tolerance/Total_Elevations.csv", header=TRUE)
###################CTMAX###########################
unique(data$CTmax)  
clean_data <- data %>%
  
  mutate(CTmax = as.numeric(as.character(CTmax))) %>%  
  
  filter(
    !is.na(CTmax),          
    CTmax >= 28             
  )

library(ggplot2)
ggplot(clean_data, aes(x = Elevation, y = CTmax)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "CTmax vs. Elevation (Total)")
#####################CTmin############################
unique(data$CTmin)  
clean_data <- data %>%
  
  mutate(CTmin = as.numeric(as.character(CTmin))) %>%  
  
  filter(
    !is.na(CTmin),          
    CTmin >= 1              
  )

library(ggplot2)
ggplot(clean_data, aes(x = Elevation, y = CTmin)) +
  geom_point(
    position = position_jitter(width = 0.02, height = 0.5),  # Reduce overlap
    alpha = 0.3,
    size = 3,
    color = "steelblue"
  ) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "CTmin vs. Elevation (Total)")

###############BODY MASS CTMAX###################
unique(data$CTmin)  
clean_data <- data %>%
  mutate(CTmin = as.numeric(as.character(CTmin))) %>%  
  filter(!is.na(CTmin),CTmin >= 1)

library(ggplot2)
ggplot(clean_data, aes(x = Live.Mass..g., y = CTmin)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "CTmin vs Mass (Total)")
####################DISTRIBUTION##############
ggplot(clean_data, aes(x = CTmax, fill = Live.Mass..g.)) +
  geom_density(alpha = 0.5) +
  labs(title = "CTmax Distribution by Body Mass")
################Statistics Test####################
cor.test(clean_data$`Live.Mass..g.`, clean_data$CTmin)

cor.test(clean_data$`Live.Mass..g.`, clean_data$CTmax)
#############Linear Model###############
clean_data$CTmin<-as.numeric(clean_data$CTmin)
cor.test(clean_data$`Elevation`, clean_data$CTmin)
model<-lm(CTmin~Elevation,data=clean_data)
summary(model)
###########################################
cor.test(clean_data$`Elevation`, clean_data$CTmax)

#################Transparency CTMIN##############
unique(data$CTmin)  # Look for "deadBeforeStart", NA, or unrealistic numbers
clean_data <- data %>%
  # Convert CTmin to numeric (non-numeric becomes NA)
  mutate(CTmin = as.numeric(as.character(CTmin))) %>%  
  # Keep only rows where:
  filter(
    !is.na(CTmin),          # Remove NA (formerly non-numeric)
    CTmin >= 1              # Remove values below 1°C
  )

library(ggplot2)
ggplot(clean_data, aes(x = Elevation, y = CTmin)) +
  geom_point(
    position = position_jitter(width = 0.02, height = 0.5),  # Reduce overlap
    alpha = 0.3,  # Fixes low opacity
    size = 5,
    color = "black"
  ) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "CTmin vs. Elevation (Total)")
##############Point SIZE#################
library(ggplot2)
library(dplyr)
library(MASS)

approx2d <- function(x, y, z, xout, yout) {
  approx_out <- rep(NA, length(xout))
  for (i in seq_along(xout)) {
    x_idx <- which.min(abs(x - xout[i]))
    y_idx <- which.min(abs(y - yout[i]))
    approx_out[i] <- z[x_idx, y_idx]
  }
  approx_out
}

#Calculate 2D kernel density
density_2d <- kde2d(
  x = clean_data$`Elevation`, 
  y = clean_data$CTmin, 
  n = 100
)

# Assign density to each point (custom function)
clean_data <- clean_data %>%
  mutate(
    density = approx2d(  # Uses helper function from earlier
      x = density_2d$x,
      y = density_2d$y,
      z = density_2d$z,
      xout = `Elevation`,
      yout = CTmin
    )
  )

# Plot with size ~ density
ggplot(clean_data, aes(x = `Elevation`, y = CTmin)) +
  geom_point(aes(size = density), 
              alpha = 0.6, 
              color = "black",
              show.legend = FALSE  # This removes the size/density legend
  ) +
  scale_size_continuous(range = c(2, 10)) +
  labs(title = "Body Mass vs. CTmax (No Legend)") +
  theme_bw() +
  theme
  geom_smooth(method = "lm", color = "red") +
  labs(title = "CTmin vs. Elevation (Total)")
####################################
ggplot(clean_data, aes(x = Elevation, y = CTmin)) +
  geom_point(
    aes(color = "CTmin Values"), 
    alpha = 0.3, 
    size = 5,
    show.legend = TRUE
  ) +
  geom_smooth(method = "lm", color = "red") +
  scale_color_manual(
    name = NULL,  # Remove legend title
    values = c("CTmin Values" = "black")
  ) +
  labs(title = "CTmin vs. Elevation (Total)") +
  theme_bw() +
  theme(
    legend.position = c(0.83, 0.96),  # X,Y coordinates inside plot (0-1 scale)
    legend.background = element_rect(fill = "white", color = "black")  
  )