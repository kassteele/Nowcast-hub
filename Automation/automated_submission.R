#
# Automated submission
#

#
# Load packages
library(here)
library(gert)


# # First fork the repos on GitHub
# # You have to do this only once
#
# # Before cloning, be sure hospitalization-nowcast-hub does not exist
# unlink(
#   here("hospitalization-nowcast-hub"),
#   recursive = TRUE)
#
# # Clone into folder hospitalization-nowcast-hub
# git_clone(
#   url = "git@github.com:kassteele/hospitalization-nowcast-hub.git",
#   path = here("hospitalization-nowcast-hub"))

# Pull remote repository into the current local branch
git_pull(
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

# Stage added file(s)
git_add(
  file = ".",
  repo = here("hospitalization-nowcast-hub"))

# Commit
git_commit(
  message = paste0("RIVM-KEW submission ", Sys.Date()),
  repo = here("hospitalization-nowcast-hub"))

# Push to my repository
git_push(
  repo = here("hospitalization-nowcast-hub"))

# Create pull request
# This is still a bit ugly with the setwd
setwd(dir = here("hospitalization-nowcast-hub"))
system(
  command = paste0("gh pr create --title \"RIVM-KEW submission ", Sys.Date(), "\" --body \"RIVM-KEW submission\""))
setwd(dir = here())

# Go back to main branch
git_branch_checkout(
  branch = "main",
  repo = here("hospitalization-nowcast-hub"))

# Remove local submission branch
git_branch_delete(
  branch = "submission",
  repo = here("hospitalization-nowcast-hub"))
