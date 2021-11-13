#
# Make data for fitting
#

# Show progress
message("Make data for fitting")

reporting_fit_data <- reporting_data %>%
  filter(
    # Only use dates back to 2*max(delay) from forecast_date
    date > forecast_date - 2*max(delay) & date <= forecast_date) %>%
  mutate(
    # Get the weekday of date and weekday of date_report
    date_report = date + delay,
    day = date %>% wday(label = TRUE),
    day_report = date_report %>% wday(label = TRUE),
    # These variables are used in the model instead of date and delay:
    # date_trans is the number days since min(date)
    # delay_trans is the sqrt of delay, because this
    # almost results in a log-linear delay effect
    date_trans = as.numeric(date - min(date)),
    delay_trans = delay %>% sqrt(),
    # I_delay_max is an indicator variable for the maximum delay category
    I_delay_max = (delay == max(delay)) %>%
      as.integer() %>%
      factor())
