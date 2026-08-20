#The purpose of this script is to generate a map specific for the collection areas I have. 
#The Tiff file for canopy cover was obtained from the NCLD database

# Load packages
library(sf)
library(terra)
library(tidyterra)     # for geom_spatraster
library(dplyr)
library(ggplot2)
library(rnaturalearth)

#defining populations and colors
pop_colors <- c(
  "Port Sheldon" = "#FE6100",
  "Rosy Mound" = "#FFB000",
  "Seven Bridges" = "#0057B8",
  "Springvale" = "#DC267F",
  "Tatum" = "#785EF0"
)
pop_labels <- c(
  "Port Sheldon" = "Port Sheldon",
  "Rosy Mound" = "Rosy Mound",
  "Seven Bridges" = "Seven Bridges",
  "Springvale" = "Springvale",
  "Tatum" = "Tatum"
)

#Data input
WildPoints <- read.csv("WildLatLong.csv", stringsAsFactors = FALSE)
#only want Eastern Boechera stricta points
unique(WildPoints$Species)
EBS <- filter(WildPoints, Species == "Eastern B. stricta")
EBS <- as.data.frame(EBS)
#need to assign populations
EBS <- EBS %>%
  mutate(
    Population = case_when(
      grepl("_PS", JL_ID) ~ "Port Sheldon",
      grepl("_RM|_Rm", JL_ID) ~ "Rosy Mound",
      grepl("_Sv", JL_ID) ~ "Springvale",
      grepl("_Sb", JL_ID) ~ "Seven Bridges",
      grepl("_TFP", JL_ID) ~ "Tatum",
      TRUE ~ NA_character_
    )
  )
#Make sure coordinates are numeric
EBS <- EBS %>%
  mutate(
    Longitude = as.numeric(Longitude),
    Latitude  = as.numeric(Latitude)
  )
#sf for plotting
EBS_sf <- st_as_sf(EBS, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)
#Basemaps
us_states <- ggplot2::map_data("state")
Michigan  <- subset(us_states, region == "michigan")
# How you can add the great lakes
lakes <- rnaturalearth::ne_download(
  scale       = "large",
  type        = "lakes",
  category    = "physical",
  returnclass = "sf"
)
great_lakes <- lakes %>%
  dplyr::filter(name %in% c("Lake Superior", "Lake Michigan", "Lake Huron", "Lake Erie", "Lake Ontario")) %>%
  sf::st_transform(4326)

# load Land cover raster
land_cover <- terra::rast("nlcd_tcc_conus_wgs84_v2023-5_20230101_20231231.tif")
land_ll <- terra::project(land_cover, "EPSG:4326")
land_mi <- crop(
  land_ll,
  terra::ext(-88, -82, 41, 46)
)
#adjusting so that the scale on the map is actually uselful
range(terra::values(land_mi), na.rm = TRUE)
#I know from a histogram that this highest value is an extreme outlier so moving forward accordingly
land_cover[land_cover >= 254] <- NA

#Plot
#sectioned it so it was easier to troubleshoot errors
#errors were process with the assistance of microsoft copilot
p <- ggplot() +
  # SpatRaster
  geom_spatraster(data = land_cover) +
  scale_fill_gradientn(
    colours = terrain.colors(80),
    limits = c(0, 85),
    oob = scales::squish,
    name = "Tree Canopy Cover (%)",
    na.value = NA
  ) +
  # Great Lakes
  geom_sf(data = great_lakes, fill = "navy", color = "steelblue", linewidth = 0.6) +
  # Michigan outline from map_data()
  geom_polygon(
    data = Michigan,
    aes(x = long, y = lat, group = group),
    fill = NA, color = "grey1", linewidth = 0.6
  ) +
  # Points - reminder: use geom_sf for sf objects
  geom_sf(
    data = EBS_sf,
    aes(color = Population),
    size  = 2.2,
    alpha = 1.2,
  ) +
  scale_color_manual(
    values = pop_colors,
    labels = pop_labels,
    name = "Population"
  ) +
  coord_sf(xlim = c(-88, -82), ylim = c(41, 46), expand = FALSE, crs = 4326) +
  theme_minimal() +
  labs(title = expression("Collections of Eastern " * italic("Boechera stricta"))) +
  ylab("Latitude") +
  xlab("Longitude")

p
