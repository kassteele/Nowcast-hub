#
# Function to calculate rolling sum over the past 7 elements of vector x
#

rolling_sum <- function(x) {
  sapply(X = seq_len(7) - 1, FUN = lag, x = x) |>
    rowSums()
}
