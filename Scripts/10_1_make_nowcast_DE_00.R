#
# Make nowcast DE 00
#

# Show progress
message("Make nowcast DE 00")

nowcast_data_DE_00 <- make_nowcast(
  fitted_gam = reporting_gam_DE_00,
  fit_data = reporting_fit_data_DE_00,
  forecast_date = forecast_date)
gc()
