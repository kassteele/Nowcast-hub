#
# Function to repair quantile names: e.g. name = "50%" -> "N_quantile_0.5"
#

repair_quantile_names <- function(name) {
  name <- name %>%
    str_remove("%") %>%
    as.numeric() %>%
    "/"(100) %>%
    as.character()
  str_glue("N_quantile_{name}")
}
