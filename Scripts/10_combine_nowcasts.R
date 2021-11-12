#
# Combine nowcasts
#

# Show progress
messsage("Combine nowcasts")

# We assume nowcast_data_DE_00 is always there
nowcast_data <- nowcast_data_DE_00

# The other two are optional
if (exists("nowcast_data_DE_not00")) {
  nowcast_data <- bind_rows(
    nowcast_data,
    nowcast_data_DE_not00)
}
if (exists("nowcast_data_notDE_00")) {
  nowcast_data <- bind_rows(
    nowcast_data,
    nowcast_data_notDE_00)
}
