library(ecoengine)
library(dplyr)
library(wesanderson)
library(leafletR)

# SUPER JANKY EMBARRASING MAP FUNCTION
# REPLACEMENT FOR ee_map()
ee_map2 <- function(eco) {
df <- eco$data


unique_species <- df %>%
count(scientific_name) %>%
arrange(desc(n))

pal <- wes_palette("Zissou", 100, type = "continuous")
colors <- pal[1:nrow(unique_species)]

# I need some variation here, goddammit
opts <-c("#FF0000", "#EDD000", "#009BB4", "#CAB19A", "#3A224A")
if(nrow(unique_species) > 5) {
  colors[1:5] <- opts[1:5]
} else {
colors[1:nrow(unique_species)] <- opts[1:nrow(unique_species)]
}

unique_species$marker_color <- colors


# Remove all the extra fields and only keep what goes in the geoJSON
filtered_df <- left_join(df, unique_species, by = "scientific_name")
filtered_df <- filtered_df %>%
				select("title" = scientific_name,
					"description" = begin_date,
					"marker-color" = marker_color,  # THis is for mapbox
					"url" = url,
					latitude,
					longitude)
# Soon I should add other mapbox options here
filtered_df$`marker-size` <- "small"
filtered_df <- filtered_df %>% mutate(description = sprintf("Collected on %s", description))
pos <- c(which(names(filtered_df) == "latitude"), which(names(filtered_df) == "longitude"))
leafletR::toGeoJSON(filtered_df, lat.lon = pos, name = "points", overwrite = TRUE)
# How can I easily cat files together without too many \n?
system("cat index0.html points.geojson index1.html > index.html")
browseURL('index.html')
}

# Some examples

# Everyone's gotta like a lynx
lynx <- ee_observations(genus = "Lynx", georeferenced = TRUE)
# We've got lots of loons too!
loons <- ee_observations(scientific_name = "Gavia immer", georeferenced = TRUE)

# pipe them into maps
lynx %>% ee_map2
loons %>% ee_map2

