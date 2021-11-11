#
# Export csv file
#

# Specifications:
# https://github.com/KITmetricslab/hospitalization-nowcast-hub/wiki/Data-format

nowcast_data %>%
  rename(
    target_end_date = date) %>%
  filter(
    target_end_date >= forecast_date - 28) %>%
  mutate(
    forecast_date = forecast_date,
    target = str_glue("{target_end_date - forecast_date} day ahead inc hosp"),
    pathogen = "COVID-19") %>%
  pivot_longer(
    cols = starts_with("N_"),
    names_sep = "_",
    names_to = c(NA, "type", "quantile"),
    values_to = "value") %>%
  select(
    location, age_group, forecast_date, target_end_date, target, type, quantile, value, pathogen) %>%
  write_csv(
    file = str_glue("Export/{forecast_date}-RIVM-KEW.csv"),
    quote = "none")
