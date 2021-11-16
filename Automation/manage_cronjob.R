#
# This script manages the cron job
#

# Load packages
library(here)
library(cronR)

# Add cron job
# Log will be added in same dir as automated_submission.R
cron_add(
  command = cron_rscript(
    rscript = here("Automation/automated_submission.R")),
  frequency = "daily",
  at = "8:00",
  id = "nowcast_hub",
  ask = FALSE)

# List cron jobs
cron_ls()

# Remove nowcast_hub job
cron_rm(
  id = "nowcast_hub",
  ask = FALSE)
