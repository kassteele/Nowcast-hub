#
# Automated submission
#

# Before we start, first check if the
# reporting triangle data has been updated
repeat {

  # Read reporting triangle data from nowcast hub
  tmp <- readLines(
    con = "https://github.com/KITmetricslab/hospitalization-nowcast-hub/blob/main/data-truth/COVID-19/COVID-19_hospitalizations_preprocessed.csv?raw=true")

  if (substr(x = tmp[length(tmp)], start = 1, stop = 10) == Sys.Date()) {
    # If there is new data, continue with automated submission
    break
  } else if (as.numeric(substr(x = Sys.time(), start = 12, stop = 13)) < 17) {
    # Else, if it is before 17:00, wait for 30 minutes and try again
    Sys.sleep(time = 1800)
  } else {
    # Else, stop trying and quit
    q(save = "no")
  }

}

# Load packages
library(here)

# These steps should be done only once:
# 1. Fork the repos hospitalization-nowcast-hub to your own GitHub
# 2. Clone repos hospitalization-nowcast-hub into local folder hospitalization-nowcast-hub
if (!file.exists(here("hospitalization-nowcast-hub"))) {
  # Be sure to set dir to folder were folder hospitalization-nowcast-hub should be created
  # If you are in Nowcast-hub.Rproj, you are ok
  dir.create(path = here("hospitalization-nowcast-hub"))
  setwd(dir = here("hospitalization-nowcast-hub"))
  system("git clone git@github.com:kassteele/hospitalization-nowcast-hub.git")
}
# 3. Add upstream (= KITmetricslab/hospitalization-nowcast-hub)
if (!any(any(grepl("upstream", system("git remote -v", intern = TRUE))))) {
  system("git remote add upstream git@github.com:KITmetricslab/hospitalization-nowcast-hub.git")
  # Check, should contain
  # origin   git@github.com:kassteele/hospitalization-nowcast-hub.git
  # upstream git@github.com:KITmetricslab/hospitalization-nowcast-hub.git
  system("git remote -v")
}
# 4. Run in terminal: gh auth login
# Done

# Set dir to local repos
setwd(dir = here("hospitalization-nowcast-hub"))

# Be sure to start in the main branch
system("git checkout main")

# Remove possible leftover submission branch
# You can ignore the error "cannot locate local branch 'submission'"
try(system("git branch -D submission"))

# Pull remote repository into the current local branch
system("git pull upstream main")

# Create local branch "submission" and check out
system("git checkout -b submission")

# Set dir to RStudio project dir
setwd(dir = here())

# Run the masterscript that does all calculations
source(file = "Scripts/00_masterscript.R")

# Copy today's file from Export folder to hospitalization-nowcast-hub/data-processed/RIVM-KEW folder
file <- paste0(Sys.Date(), "-RIVM-KEW.csv")
file.copy(
  from = here("Export", file),
  to = here("hospitalization-nowcast-hub/data-processed/RIVM-KEW"))

# Set dir to local repos
setwd(dir = here("hospitalization-nowcast-hub"))

# Stage today's file
system(paste0("git add data-processed/RIVM-KEW/", file))

# Commit
system(paste0("git commit -m 'Update nowcasts (RIVM) ", Sys.Date(), "'"))

# Push submission branch to my repository (origin)
system("git push --set-upstream origin submission")

# Create pull request
system(paste0("gh pr create --title \"Update nowcasts (RIVM) ", Sys.Date(), "\" --body \"Update nowcasts (RIVM)\" --repo \"KITmetricslab/hospitalization-nowcast-hub\""))

# Go back to main branch
system("git checkout main")
system("git push origin main")

# Remove local submission branch
system("git branch -D submission")

# Send confirmation e-mail
source(file = "../Automation/send_e-mail.R")
