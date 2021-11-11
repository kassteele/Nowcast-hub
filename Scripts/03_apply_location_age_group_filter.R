#
# Apply filter
#

# There is currently no need to stratify by location not DE and age_group not 00+
reporting_data_raw <- reporting_data_raw %>%
  filter(
    !(location != "DE" & age_group != "00+"))
