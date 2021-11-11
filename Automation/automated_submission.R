#
# Automated submission
#
# This script runs on a cron job every day
# It updates the fork on my own GitHub page
#

#
# Load packages
library(here)
library(gert)

# First fork the repos on GitHub

# Before cloning, be sure hospitalization-nowcast-hub does not exist
unlink(
  here("hospitalization-nowcast-hub"),
  recursive = TRUE)

# Clone
# This clones into folder "test"
# You have to do this only once
git_clone(
  url = "git@github.com:kassteele/hospitalization-nowcast-hub.git",
  path = here("hospitalization-nowcast-hub"))

# Change directory to test
# Now git becomes active
setwd(dir = here("hospitalization-nowcast-hub"))

# Add remote from original repository into my forked repository
git_remote_add(
  url = "git@github.com:KITmetricslab/hospitalization-nowcast-hub.git",
  repo = here("hospitalization-nowcast-hub"),
  name = "upstream")
git_fetch(
  remote = "upstream",
  repo = here("hospitalization-nowcast-hub"))

# Fetch remote repository into the current local branch
git_pull(
  remote = "upstream",
  repo = here("hospitalization-nowcast-hub"))

# Create local submission branch and check out
git_branch_create(
  branch = "submission",
  repo = here("hospitalization-nowcast-hub"))

# Run the masterscript that does all calculations
source(file = here("Scripts/00_masterscript.R"))

# Copy (new) files to hospitalization-nowcast-hub/data-processed/RIVM-KEW
file.copy(
  from = list.files(here("Export"), full.names = TRUE),
  to = here("hospitalization-nowcast-hub/data-processed/RIVM-KEW"))

# Stage all added file(s)
git_add(
  file = ".")

# Commit
git_commit(
  message = paste0("RIVM-KEW submission ", Sys.Date()))

# Push to my repository
git_push()

# Create pull request
system(
  command = paste0("gh pr create --title \"RIVM-KEW submission ", Sys.Date(), "\""))

# Go back to main branch
git_branch_checkout(
  branch = "main")

# Remove local submission branch
git_branch_delete(
  branch = "submission")
