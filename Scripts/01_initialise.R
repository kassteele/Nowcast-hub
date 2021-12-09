#
# Initialisation
#

# Show progress
message("Initialisation")

# Load packages
library(tidyverse)
library(lubridate)
library(colorspace)
library(mgcv)

# Source functions
walk(
  .x = list.files(path = "Functions", full.names = TRUE),
  .f = source)

# Set time locale to English
Sys.setlocale(category = "LC_TIME", locale = "en_US.UTF-8")

# Weeks start on Monday
options(lubridate.week.start = 1)

# Set maximum delay
max_delay <- 80L

# Number of Monte Carlo simulations for nowcast
n_sim <- 1000

# Set forecast_date
forecast_date <- today()
