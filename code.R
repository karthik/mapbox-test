library(ecoengine)
library(dplyr)
library(wesanderson)

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
colors[1:nrow(unique_species)] <- opts[1:nrow(unique_species)]
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

# Why does geojson_write change marker-color to marker.color?
geojsonio::geojson_write(filtered_df, lat = "latitude", lon = "longitude", file = "points.geojson")
# Which forces me to have this ugly system sed. :(
system("sed 's/marker.color/marker-color/' points.geojson > f1.geojson")
system("sed 's/marker.size/marker-size/' f1.geojson > f2.geojson")
# How can I easily cat files together without too many \n?
system("cat index0.html f2.geojson index1.html > index.html")
file.remove(c('f1.geojson', 'f2.geojson', 'points.geojson'))
browseURL('index.html')
}

# Other examples

z1 <- ee_observations(genus = "Lynx", georeferenced = TRUE)


loons <- ee_observations(scientific_name = "Gavia immer", georeferenced = TRUE)

z1 %>% ee_map2
loons %>% ee_map2

