#
# Plot reporting triangles
#

# Show progress
message("Plot reporting triangles")

# Create plots
plot_reporting_triangles <- map(
  .x = reporting_data %>%
    split(
      f = list(.$location, .$age_group),
      drop = TRUE,
      sep = "_"),
  .f = ~ ggplot(
    data = .x,
    mapping = aes(x = date, y = delay, fill = n_rep)) +
    geom_raster() +
    scale_x_date(
      date_breaks = "1 week",
      date_minor_breaks = "1 day",
      date_labels = "%e %b",
      expand = expansion(add = c(1, 1))) +
    scale_y_continuous(
      expand = expansion(add = c(1, 1))) +
    scale_fill_continuous_sequential(
      palette = "Blues",
      trans = "log1p") +
    coord_equal() +
    labs(
      title = str_glue("{.x$location} {.x$age_group}")) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(
        angle = 90,
        hjust = 1, vjust = 0.5)))

# # Open connection to multipage pdf
# pdf(
#   file = "Figures/reporting_triangles.pdf",
#   onefile = TRUE)
#
# # Print
# plot_reporting_trianangles
#
# # Close connection to pdf
# dev.off()
