#
# This script manages the cron job
#

# Load packages
library(cronR)

# Add cron job
# This job runs on server rs4.rivm.nl
# Log will be added in same dir as automated_submission.R
cron_add(
  command = cron_rscript(
    rscript = "/home/kasstvdj/Scripts/Nowcast-hub/Automation/automated_submission.R",
    workdir = "/home/kasstvdj/Scripts/Nowcast-hub",
    log_append = FALSE),
  frequency = "daily",
  at = "6:00",
  id = "nowcast_hub",
  ask = FALSE)

# List cron jobs
cron_ls()

# Remove nowcast_hub job
cron_rm(
  id = "nowcast_hub",
  ask = FALSE)
