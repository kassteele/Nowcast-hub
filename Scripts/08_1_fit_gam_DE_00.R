#
# Fit gam model DE 00
#

# Show progress
message("Fit gam model DE 00")

reporting_gam_DE_00 <- bam(
  formula = n_rep ~
    s(date_trans, bs = "ps", k = 20) +
    s(delay_trans, bs = "ps", k = 20) +
    s(day, bs = "re") +
    s(day_report, bs = "re") +
    s(I_delay_max, bs = "re", k = 2),
  family = nb,
  data = reporting_fit_data_DE_00,
  discrete = TRUE,
  nthreads = 2)
