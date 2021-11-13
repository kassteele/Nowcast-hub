#
# Tidy data
#

# Show progress
message("Tidy data")

reporting_data <- reporting_data_raw %>%
  mutate(
    # Convert characters location and age_group to factors
    # This to ensure that the order is the same as in the raw data
    location = location %>% fct_inorder(),
    age_group = age_group %>% fct_inorder(),
    # Looking at the reporting triangle, there seems to be an inconsistancy at delay 79d, 80d and >80d
    # There should be an NA at delay >80d and date = forecast_date - max(delay) + 1
    # Collapse columns delay 80d and >80d into >=80d
    value_80d = cbind(value_80d, `value_>80d`) %>% rowSums()) %>%
  # Remove column value_>80d. Not needed anymore
  select(
    -`value_>80d`) %>%
  # Convert to tidy format
  # The delay comes from the number in the value_{**}d columns
  # The true number of hospitalisations by date and delay is called n_true
  pivot_longer(
    cols = starts_with("value"),
    values_to = "n_true",
    values_transform = list(n_true = as.integer),
    names_to = "delay",
    names_pattern = "value_(\\d{1,2})d",
    names_transform = list(delay = as.integer)) %>%
  # Relocate date before delay
  relocate(
    date, .before = delay) %>%
  # Arrange records
  arrange(
    location, age_group, date, delay)
