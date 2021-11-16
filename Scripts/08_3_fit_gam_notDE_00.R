#
# Fit gam model not DE 00
#

# Show progress
message("Fit gam model not DE 00")

reporting_gam_notDE_00 <- bam(
  formula = n_rep ~
    s(date_trans, bs = "ps", k = 20) +
    s(delay_trans, bs = "ps", k = 20) +
    s(day, bs = "re") +
    s(day_report, bs = "re") +
    s(I_delay_max, bs = "re") +
    s(location, bs = "re") +
    ti(date_trans, location, bs = c("ps", "re"), k = c(5, 16)) +
    ti(delay_trans, location, bs = c("ps", "re"), k = c(5, 16)) +
    ti(day, location, bs = "re") +
    ti(day_report, location, bs = "re") +
    ti(I_delay_max, location, bs = "re"),
  family = nb,
  data = reporting_fit_data_notDE_00,
  discrete = TRUE,
  select = TRUE)
