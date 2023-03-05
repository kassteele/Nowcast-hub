#
# Plot epicurves
#

# Show progress
message("Plot epicurves")

# This is what the plots have in common
plot_epicurves_common <- list(
  geom_ribbon(
    mapping = aes(x = date, ymin = N_quantile_0.025, ymax = N_quantile_0.975),
    fill = 4,
    alpha = 0.5),
  geom_line(
    mapping = aes(x = date, y = N_rep),
    col = "grey"),
  geom_line(
    mapping = aes(x = date, y = N_true)),
  geom_line(
    mapping = aes(x = date, y = N_quantile_0.5),
    colour = 4),
  scale_x_date(
    date_breaks = "2 weeks",
    date_minor_breaks = "1 week",
    date_labels = "%e %b",
    expand = expansion(add = c(1, 1))),
  scale_y_continuous(
    limits = c(0, NA),
    expand = expansion(add = c(1, 1))),
  labs(
    x = "Meldedatum",
    y = "7-day hospitalization incidence"),
  facet_wrap(
    facets = vars(location, age_group),
    ncol = 2,
    scales = "free_y",
    labeller = label_wrap_gen(multi_line = FALSE)),
  theme_minimal(),
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1, vjust = 0.5)))

# Epicurve total
plot_epicurves_total <- ggplot(
  data = epicurve_data |>
    filter(location == "DE" & age_group == "00+")) +
  plot_epicurves_common

# Epicurves by age group
plot_epicurves_agegroup <- ggplot(
  data = epicurve_data |>
    filter(location == "DE" & age_group != "00+")) +
  plot_epicurves_common

# Epicurves by location
plot_epicurves_location <- ggplot(
  data = epicurve_data |>
    filter(location != "DE" & age_group == "00+")) +
  plot_epicurves_common
