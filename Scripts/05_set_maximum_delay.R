#
# Set maximum delay
#

# Show progress
message("Set maximum delay")

# In the raw data the maximum delay is 81 days (see script tidy_data.R)
# where delay = 81 contains all delays >80 days
# Here we set a maximum delay to a given value: max_delay (see script initialize.R)
# and aggregate all delays >= max_delay into delay = max_delay
reporting_data <- reporting_data |>
  mutate(
    delay = if_else(
      condition = delay >= max_delay,
      true = max_delay,
      false = delay)) |>
  group_by(
    location, age_group, date, delay) |>
  summarise(
    n_true = sum(n_true),
    .groups = "drop")

# Complete reporting matrix by date and delay
# This sets n_true to NA outside the reporting triangle, as in the raw data
# We need this explicit NA's in function make_nowcast()
reporting_data <- reporting_data |>
  complete(
    location, age_group, date, delay)
