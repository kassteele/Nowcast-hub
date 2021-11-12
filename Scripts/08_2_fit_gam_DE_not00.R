#
# Fit gam model DE not 00
#

# Show progress
messsage("Fit gam model DE not 00")

reporting_gam_DE_not00 <- bam(
  formula = n_rep ~
    s(date_trans, bs = "ps", k = 20) +
    s(delay_trans, bs = "ps", k = 20) +
    s(day, bs = "re") +
    s(day_report, bs = "re") +
    s(I_delay_max, bs = "re") +
    s(age_group, bs = "re") +
    ti(date_trans, age_group, bs = c("ps", "re"), k = c(5, 6)) +
    ti(delay_trans, age_group, bs = c("ps", "re"), k = c(5, 6)) +
    ti(day, age_group, bs = "re") +
    ti(day_report, age_group, bs = "re") +
    ti(I_delay_max, age_group, bs = "re"),
  family = nb,
  data = reporting_fit_data_DE_not00,
  discrete = TRUE,
  select = TRUE,
  nthreads = n_cores)
