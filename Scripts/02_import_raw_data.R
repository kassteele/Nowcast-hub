#
# Import raw data
#

# Show progress
message("Import raw data")

# Download raw reporting data from nowcast hub
reporting_data_raw <- read_csv(
  file = "https://github.com/KITmetricslab/hospitalization-nowcast-hub/blob/main/data-truth/COVID-19/COVID-19_hospitalizations_preprocessed.csv?raw=true",
  show_col_types = FALSE)

# Stop if there is no new data
if (reporting_data_raw %>% pull(date) %>% last() != today()) {
  rm(reporting_data_raw)
  stop("Raw reporting triangle data has not been updated yet")
}
