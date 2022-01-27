#
# Plot reporting triangles
#

# Show progress
message("Plot reporting triangles")

# This is what the plots have in common
plot_reporting_triangles_common <- list(
  geom_raster(
    mapping = aes(x = date, y = delay, fill = n_rep)),
  scale_x_date(
    date_breaks = "2 weeks",
    date_minor_breaks = "1 week",
    date_labels = "%e %b",
    expand = expansion(add = c(1, 1))),
  scale_y_continuous(
    expand = expansion(add = c(1, 1))),
  scale_fill_continuous_sequential(
    palette = "Blues",
    na.value = "grey75",
    breaks = c(0, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000),
    trans = "log1p"),
  coord_equal(),
  labs(
    x = "Meldedatum",
    y = "Delay",
    fill = "n"),
  facet_wrap(
    facets = vars(location, age_group),
    ncol = 2,
    labeller = label_wrap_gen(multi_line = FALSE)),
  theme_minimal(),
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1, vjust = 0.5)))

# Reporting triangle total
plot_reporting_triangles_total <- ggplot(
  data = reporting_data %>%
    filter(location == "DE" & age_group == "00+")) +
  plot_reporting_triangles_common

# Reporting triangles by age group
plot_reporting_triangles_agegroup <- ggplot(
  data = reporting_data %>%
    filter(location == "DE" & age_group != "00+")) +
  plot_reporting_triangles_common

# Reporting triangles by location
plot_reporting_triangles_location <- ggplot(
  data = reporting_data %>%
    filter(location != "DE" & age_group == "00+")) +
  plot_reporting_triangles_common
