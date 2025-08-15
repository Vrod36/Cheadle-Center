install.packages("tidyverse")
install.packages("MASS")

library(tidyverse)
library(MASS)

data <- read.csv("C:/Users/victo/Downloads/Thermal Tolerance/Data.csv")


# Data cleaning and preparation
clean_data <- data %>%
  # Remove rows with missing CTmax or CTmin values
  filter(!is.na(CTmax) | !is.na(CTmin)) %>%
  # Convert appropriate columns to numeric
  mutate(across(c(Live.Mass..g., ITD..mm., CTmin, CTmax, Elevation), as.numeric)) %>%
  # Convert sex to factor (and handle missing/empty values)
  mutate(Sex = ifelse(is.na(Sex) | Sex == "", "Unknown", Sex),
         Sex = as.factor(Sex)) %>%
  # Convert date to Date format
  mutate(Date = as.Date(Date, format = "%d-%b-%y")) %>%
  # Remove empty factor levels
  mutate(across(where(is.factor), ~droplevels(.x)))

# Function to remove problematic columns (all NA or factors with <2 levels)
remove_bad_columns <- function(df) {
  # Identify columns to keep
  cols_to_keep <- sapply(df, function(x) {
    !(all(is.na(x)) || (is.factor(x) && nlevels(x) < 2))
  })
  # Return dataframe with only good columns
  df[, cols_to_keep, drop = FALSE]
}


# For CTmax analysis (using only rows with CTmax values)
ctmax_data <- clean_data %>% 
  filter(!is.na(CTmax)) %>%
  remove_bad_columns()

# For CTmin analysis (using only rows with CTmin values)
ctmin_data <- clean_data %>% 
  filter(!is.na(CTmin)) %>%
  remove_bad_columns()


# Rest of the code remains the same from previous version...
perform_stepwise <- function(response_var, data) {
  # Identify potential predictors (excluding response and ID variables)
  potential_preds <- setdiff(names(data), 
                             c(response_var, "Catalog.Number", "Vial..", "Pin.Weight"))
  
  # Remove predictors with too many missing values (>50% missing)
  preds_to_keep <- sapply(potential_preds, function(x) {
    if(is.numeric(data[[x]])) {
      sum(is.na(data[[x]])) / nrow(data) < 0.5
    } else TRUE
  })
  
  predictors <- potential_preds[preds_to_keep]
  
  # Create formula for full model
  full_formula <- as.formula(paste(response_var, "~", paste(predictors, collapse = "+")))
  
  
  
  # Create null model (intercept only)
  null_formula <- as.formula(paste(response_var, "~ 1"))
  
  # Perform stepwise regression with error handling
  tryCatch({
    step_model <- stepAIC(
      lm(null_formula, data = data),
      scope = list(lower = null_formula, upper = full_formula),
      direction = "both",
      trace = FALSE
    )
    return(step_model)
  }, error = function(e) {
    message("Error in stepwise regression: ", e$message)
    return(NULL)
  })
}



# Perform stepwise regression for CTmax
ctmax_model <- perform_stepwise("CTmax", ctmax_data)

# Perform stepwise regression for CTmin
ctmin_model <- perform_stepwise("CTmin", ctmin_data)

# Print results if models were successfully created
if(!is.null(ctmax_model)) {
  cat("\n=== Stepwise Regression Results for CTmax ===\n")
  print(summary(ctmax_model))
  cat("\nSignificant predictors for CTmax:\n")
  print(names(coef(ctmax_model))[-1]) # Remove intercept
} else {
  cat("\nCould not create CTmax model due to data issues\n")
}



if(!is.null(ctmin_model)) {
  cat("\n=== Stepwise Regression Results for CTmin ===\n")
  print(summary(ctmin_model))
  cat("\nSignificant predictors for CTmin:\n")
  print(names(coef(ctmin_model))[-1]) # Remove intercept
} else {
  cat("\nCould not create CTmin model due to data issues\n")
}

# Visualize the results if models exist
if(!is.null(ctmax_model)) {
  par(mfrow = c(2, 2))
  plot(ctmax_model)
  title("CTmax Model Diagnostics", line = 3)
}

if(!is.null(ctmin_model)) {
  par(mfrow = c(2, 2))
  plot(ctmin_model)
  title("CTmin Model Diagnostics", line = 3)
}



if(!is.null(ctmax_model)) {
  par(mfrow = c(2, 2))  # Sets up 2x2 grid for plots
  plot(ctmax_model, which = 1:4)  # Ensures all 4 diagnostic plots are shown
  title("CTmax Model Diagnostics", outer = TRUE, line = -1)
}

if(!is.null(ctmin_model)) {
  par(mfrow = c(2, 2))
  plot(ctmin_model, which = 1:4)
  title("CTmin Model Diagnostics", outer = TRUE, line = -1)
}
  
  png("CTmax_diagnostics.png", width=800, height=800)
  par(mfrow=c(2,2))
  plot(ctmax_model)
  dev.off()