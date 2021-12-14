#
# Automated submission
#

# Before we start, first check if the
# reporting triangle data has been updated
repeat {

  # Read reporting triangle data from nowcast hub
  tmp <- readLines(
    con = "https://github.com/KITmetricslab/hospitalization-nowcast-hub/blob/main/data-truth/COVID-19/COVID-19_hospitalizations_preprocessed.csv?raw=true")

  # If there is new data, continue with automated submission
  # else, wait for 30 minutes and try again
  if (substr(x = tmp[length(tmp)], start = 1, stop = 10) == Sys.Date()) {
    break
  } else {
    Sys.sleep(time = 1800)
  }

}

# Load packages
library(here)
library(gert)

# These steps should be done only once:
# 1. Fork the repos on GitHub
# 2. Clone into folder hospitalization-nowcast-hub
if (!file.exists(here("hospitalization-nowcast-hub"))) {
  git_clone(
    url = "git@github.com:kassteele/hospitalization-nowcast-hub.git",
    path = here("hospitalization-nowcast-hub"))
}
# 3. Add upstream (= KITmetricslab/hospitalization-nowcast-hub)
if (!any(git_remote_list()$name == "upstream")) {
  git_remote_add(
    url = "git@github.com:KITmetricslab/hospitalization-nowcast-hub.git",
    name = "upstream")
}
# 4. Run in terminal: gh auth login
# Done

# Set dir to local repos
setwd(
  dir = here("hospitalization-nowcast-hub"))

# Be sure to start in the main branch
git_branch_checkout(
  branch = "main")

# Remove possible leftover submission branch
# You can ignore the error "cannot locate local branch 'submission'"
try(git_branch_delete(
  branch = "submission"))

# Pull remote repository into the current local branch
git_pull(
  remote = "upstream",
  rebase = TRUE)

# Create local submission branch and check out
git_branch_create(
  branch = "submission")

# Set dir to RStudio project dir
setwd(
  dir = here())

# Run the masterscript that does all calculations
source(
  file = "Scripts/00_masterscript.R")

# Copy (new) files to hospitalization-nowcast-hub/data-processed/RIVM-KEW
file.copy(
  from = list.files(here("Export"), full.names = TRUE),
  to = here("hospitalization-nowcast-hub/data-processed/RIVM-KEW"))

# Set dir to local repos
setwd(
  dir = here("hospitalization-nowcast-hub"))

# Stage added file(s)
git_add(
  file = ".")

# Commit
git_commit(
  message = paste0("RIVM-KEW submission ", Sys.Date()))

# Push to my repository (origin)
git_push()

# Create pull request
system(
  command = paste0("gh pr create --title \"RIVM-KEW submission ", Sys.Date(), "\" --body \"RIVM-KEW submission\" --repo \"KITmetricslab/hospitalization-nowcast-hub\""))

# Go back to main branch
git_branch_checkout(
  branch = "main")

# Remove local submission branch
git_branch_delete(
  branch = "submission")

# Send confirmation e-mail
source(
  file = "../Automation/send_e-mail.R")
