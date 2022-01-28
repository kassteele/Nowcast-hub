#
# Function to make nowcast from fitted gam and data used for fitting
#

make_nowcast <- function(fitted_gam, fit_data, forecast_date) {

  # Filter records inside the reporting triangle
  # For nowcasting, in principle we only need the records where n_rep is not NA for forcast_date - max(delay)
  # However, because of the 7d-rolling sum, we start 6 days before forcast_date - max(delay)
  data_inside_triangle <- fit_data %>%
    filter(
      !is.na(n_rep) & date > forecast_date - max(delay) - 6)

  # Filter records outside the reporting triangle
  # For these records we are going to predict the counts
  data_outside_triangle <- fit_data %>%
    filter(
      is.na(n_rep))

  # Construct the corresponding model matrix
  X <- predict(
    object = fitted_gam,
    newdata = data_outside_triangle,
    type = "lpmatrix")

  # Seed seed
  set.seed(1)

  # Get estimated model parameters
  # - beta is sampled from a multivariate normal distribution
  # - theta is fixed
  beta <- rmvn(
    n = n_sim,
    mu = coef(fitted_gam),
    V = vcov(fitted_gam))
  theta <- fitted_gam$family$getTheta(TRUE)

  # The expected number of counts follows from the model matrix X and beta
  # This is an nrow(X) x n_sim matrix
  mu <- exp(X %*% t(beta))

  # Counts outside the reporting triangle are sampled from
  # the predictive distribution, i.e. negative binomial
  # This creates an nrow(X) x n_sim matrix column in data_outside_triangle
  # We use the column name n_rep here, because this makes the binding
  # with the records inside the triangle much easier
  data_outside_triangle <- data_outside_triangle %>%
    mutate(
      n_rep = rnbinom(
        n = n()*n_sim,
        mu = mu,
        size = theta) %>%
        matrix(
          nrow = n(),
          ncol = n_sim))

  # Row bind records inside and outside the reporting triangle
  # This automatically replicates n_rep inside the reporting triangle n_sim times
  # Arrange records as in the original data
  data_nowcast <- bind_rows(
    data_inside_triangle,
    data_outside_triangle) %>%
    arrange(
      location, age_group, date, delay)

  # Get number of distinct dates and delays in data_nowcast
  n_dates <- data_nowcast %>% pull(date) %>% n_distinct()
  n_delays <- data_nowcast %>% pull(delay) %>% n_distinct()

  # Do the magic
  data_nowcast %>%
    # For each combination of location and age_group
    group_split(
      location, age_group) %>%
    map_dfr(
    .f = function(data) {
      # N is the total count by date
      # This is an n_dates x n_sim matrix
      N <- data %>%
        # Extract n_rep
        # This is an [n_delays x n_dates] x n_sim matrix
        pull(
          n_rep) %>%
        # Force this matrix into an array
        # This is an n_delays x n_dates x n_sim array
        array(
          dim = c(n_delays, n_dates, n_sim)) %>%
        # Sum over the delays: N = sum(n)
        # This is an n_dates x n_sim matrix
        apply(
          MARGIN = c(2, 3),
          FUN = sum) %>%
        # Apply rolling sum to N over the dates
        # This still is an n_dates x n_sim matrix
        apply(
          MARGIN = 2,
          FUN = rolling_sum)

      # Drop row 1:6 because these are NA
      # You cannot calculate a 7d-rolling sum over <7 days
      N <- N[-(1:6), ]

      # Calculate statistics of N by date
      # This is an n_dates x 8 tibble (1 mean and 7 quantiles)
      # The naming is such that pivoting to the desired output format is straightforward
      N_stat <- bind_cols(
        N_mean_NA = N %>%
          apply(
            MARGIN = 1,
            FUN = mean),
        N_quantile = N %>%
          apply(
            MARGIN = 1,
            FUN = quantile,
            probs = c(0.025, 0.1, 0.25, 0.5, 0.75, 0.9, 0.975)) %>%
          t() %>%
          as_tibble(
            .name_repair = repair_quantile_names))

      # Create the final tibble the current location and age_group combination
      # Here location, age_group and date are added to N_stat
      bind_cols(
        data %>%
          filter(
            date > forecast_date - max(delay)) %>%
          distinct(
            location, age_group, date),
        N_stat)
    }
  )
}
