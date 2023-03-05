#
# Tidy data
#

# Show progress
message("Tidy data")

reporting_data <- reporting_data_raw |>
  mutate(
    # Convert characters location and age_group to factors
    # This to ensure that the order is the same as in the raw data
    location = location |> fct_inorder(),
    age_group = age_group |> fct_inorder()) |>
  # Rename column value_>80d to value_81d
  rename(
    "value_81d" = "value_>80d") |>
  # Convert to tidy format
  # The delay comes from the number in the value_{**}d columns
  # The true number of hospitalisations by date and delay is called n_true
  pivot_longer(
    cols = starts_with("value"),
    names_to = "delay",
    names_pattern = "value_(\\d{1,2})d",
    names_transform = list(delay = as.integer),
    values_to = "n_true",
    values_transform = list(n_true = as.integer),
    values_drop_na = TRUE) |>
  # Relocate date before delay
  relocate(
    date, .before = delay) |>
  # Arrange records
  arrange(
    location, age_group, date, delay)
