#
# Make nowcast DE not 00
#

# Show progress
message("Make nowcast DE not 00")

nowcast_data_DE_not00 <- make_nowcast(
  fitted_gam = reporting_gam_DE_not00,
  fit_data = reporting_fit_data_DE_not00)
gc()
