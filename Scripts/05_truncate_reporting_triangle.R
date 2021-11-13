#
# Truncate reporting triangle
#

# Show progress
message("Truncate reporting triangle")

# The reporting triangle is truncated up to forecast_date
# In a real-time setting this happens naturally
# n_rep is set to NA if date + delay > forecast_date
# If not, n_rep is equal to n_true
# This forced trunction is useful for evaluating the nowcast retrospectively
reporting_data <- reporting_data %>%
  mutate(
    n_rep = if_else(
      condition = date + delay > forecast_date,
      true = NA_integer_,
      false = n_true))
