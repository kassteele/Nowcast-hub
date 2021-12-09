#
# Nowcasting German COVID-19 hospitalizations
#
# Author:
# Jan van de Kassteele
# National Institute for Public Health and the Environment - RIVM
# Bilthoven, The Netherlands
#
# This R script is based on the paper:
# Nowcasting the number of new symptomatic cases during infectious disease outbreaks using constrained P-spline smoothing
# J van de Kassteele, PHC Eilers, J Wallinga
# Epidemiology, 2019, 30(5), 737
#
# More infomation about the Hospitalization Nowcast Hub:
# https://github.com/KITmetricslab/hospitalization-nowcast-hub

source(file = "Scripts/01_initialise.R")
source(file = "Scripts/02_import_raw_data.R")
source(file = "Scripts/03_apply_location_age_group_filter.R")
source(file = "Scripts/04_tidy_data.R")
source(file = "Scripts/05_set_maximum_delay.R")
source(file = "Scripts/05_truncate_reporting_triangle.R")
source(file = "Scripts/06_make_fit_data.R")
source(file = "Scripts/07_split_fit_data.R")
source(file = "Scripts/08_1_fit_gam_DE_00.R")
source(file = "Scripts/08_2_fit_gam_DE_not00.R")
source(file = "Scripts/08_3_fit_gam_notDE_00.R")
source(file = "Scripts/09_1_make_nowcast_DE_00.R")
source(file = "Scripts/09_2_make_nowcast_DE_not00.R")
source(file = "Scripts/09_3_make_nowcast_notDE_00.R")
source(file = "Scripts/10_combine_nowcasts.R")
source(file = "Scripts/11_make_epicurves.R")
source(file = "Scripts/12_plot_reporting_triangles.R")
source(file = "Scripts/13_plot_epicurves.R")
source(file = "Scripts/14_export_csv_file.R")
