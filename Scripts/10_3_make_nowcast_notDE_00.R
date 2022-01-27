#
# Make nowcast not DE 00
#

# Show progress
message("Make nowcast not DE 00")

nowcast_data_notDE_00 <- make_nowcast(
  fitted_gam = reporting_gam_notDE_00,
  fit_data = reporting_fit_data_notDE_00)
gc()
