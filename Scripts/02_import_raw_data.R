#
# Import data
#

# Download raw reporting data from nowcast hub
reporting_data_raw <- read_csv(
  file = "https://github.com/KITmetricslab/hospitalization-nowcast-hub/blob/main/data-truth/COVID-19/COVID-19_hospitalizations_preprocessed.csv?raw=true",
  show_col_types = FALSE)
