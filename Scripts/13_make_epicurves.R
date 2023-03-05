#
# Make epicurves
#

# Show progress
message("Make epicurves")

# The epicurve contains the entire time series in reporting_data
# combined with the nowcasted hospitalizations in data_nowcast

epicurve_data <- list(
  #  N_true = epivurve over entire time series up to today
  reporting_data |>
    group_by(
      location, age_group, date) |>
    summarize(
      N_true = n_true |> sum(na.rm = TRUE)) |>
    mutate(
      N_true = N_true |> rolling_sum()) |>
    ungroup(),
  # N_rep = epivurve over time series up to forecast_date
  reporting_data |>
    filter(
      date <= forecast_date) |>
    group_by(
      location, age_group, date) |>
    summarize(
      N_rep = n_rep |> sum(na.rm = TRUE)) |>
    mutate(
      N_rep = N_rep |> rolling_sum()) |>
    ungroup(),
  # N_mean, N_quantile etc. = nowcasted epicurve up to forecast_date
  nowcast_data) |>
  reduce(
    .f = left_join)
