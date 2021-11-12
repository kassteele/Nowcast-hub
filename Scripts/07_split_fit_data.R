#
# Split fit data
#

# Show progress
messsage("Split fit data")

# The dataset for fitting is split into three parts
# Each split gets its own model and nowcast
# Between the parentheses is the number of groups
# Excluded split: location not DE & age_group not 00+ (16 x 6 = 96)

# 1. location DE & agegroup 00+ (1 x 1 = 1)
reporting_fit_data_DE_00 <- reporting_fit_data %>%
  filter(
    location == "DE" & age_group == "00+") %>%
  droplevels()

# 2. location DE & age_group not 00+ (1 x 6 = 6)
reporting_fit_data_DE_not00 <- reporting_fit_data %>%
  filter(
    location == "DE" & age_group != "00+")%>%
  droplevels()

# 3. location not DE & age_group 00+ (16 x 1 = 16)
reporting_fit_data_notDE_00 <- reporting_fit_data %>%
  filter(
    location != "DE" & age_group == "00+")%>%
  droplevels()
