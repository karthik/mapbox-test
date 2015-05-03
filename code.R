library(ecoengine)
library(dplyr)
library(wesanderson)

# SUPER JANKY EMBARRASING MAP FUNCTION
# REPLACEMENT FOR ee_map()
ee_map2 <- function(eco) {
df <- eco$data
unique_species <- df %>%
						group_by(scientific_name) %>%
						summarise(n = n()) %>% arrange(desc(n))
pal <- wes_palette("Zissou", 100, type = "continuous")
colors <- pal[1:nrow(unique_species)]
# I need some variation here, goddammit
if(nrow(unique_species) > 5) {
colors[1:5] <- c("#c0392b","#27ae60", "#f1c40f", "#3498db", "#3498db")
} else {
opts <- c("#c0392b","#27ae60", "#f1c40f", "#3498db", "#3498db")
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
					latitude, longitude)
filtered_df$`marker-size` <- "medium"

library(geojsonio)
# Why does geojson_write change marker-color to marker.color?
geojson_write(filtered_df, lat = "latitude", lon = "longitude", file = "points.geojson")
system("sed 's/marker.color/marker-color/' points.geojson > f1.geojson")
system("sed 's/marker.size/marker-size/' f1.geojson > f2.geojson")
system("cat index0.html f2.geojson index1.html > index.html")
file.remove('f1.geojson')
file.remove('f2.geojson')
file.remove('points.geojson')
browseURL('index.html')
}

# Other examples

ee_observations(genus = "Lynx", georeferenced = TRUE) %>% ee_map2


loons <- ee_observations(scientific_name = "Gavia immer", georeferenced = TRUE)

loons %>% ee_map2

