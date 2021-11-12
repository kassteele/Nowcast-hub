#
# Plot epicurves
#

# Show progress
messsage("Plot epicurves")

plot_epicurves <- map(
  .x = epicurve_data %>%
    split(
      f = list(.$location, .$age_group),
      drop = TRUE,
      sep = "_"),
  .f = ~ ggplot(
    data = .x,
    mapping = aes(x = date)) +
    geom_ribbon(
      mapping = aes(ymin = N_quantile_0.025, ymax = N_quantile_0.975),
      fill = 4,
      alpha = 0.5) +
    geom_line(
      mapping = aes(y = N_rep),
      col = "grey") +
    geom_line(
      mapping = aes(y = N_true)) +
    geom_line(
      mapping = aes(y = N_quantile_0.5),
      colour = 4) +
    scale_x_date(
      date_breaks = "1 week",
      minor_breaks = NULL,
      date_labels = "%e %b",
      expand = expansion(add = c(1, 1))) +
    scale_y_continuous(
      limits = c(0, NA),
      expand = expansion(add = c(1, 1))) +
    labs(
      title = str_glue("{.x$location} {.x$age_group}")) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(
        angle = 90,
        hjust = 1, vjust = 0.5)))
