library(ecoengine)
library(dplyr)
library(wesanderson)

# This is an example query that gets 1000 observations
x <- ee_observations(genus = "vulpes", georeferenced = TRUE)
# Get unique species so we can add colors
unique_species <- x$data %>% 
						group_by(scientific_name) %>% 
						summarise(n = n()) %>% arrange(desc(n))
pal <- wes_palette("Zissou", 100, type = "continuous")
colors <- pal[1:nrow(unique_species)]
# I need some variation here
colors[1:5] <- ("#c0392b", "#27ae60", "#f1c40f", "#3498db", "#3498db")
unique_species$marker_color <- colors


filtered_df <- left_join(x$data, unique_species, by = "scientific_name")
filtered_df <- filtered_df %>% 
				select("title" = scientific_name, 
					"description" = begin_date, 
					"marker-color" = marker_color, 
					latitude, longitude)

head(filtered_df)
library(geojsonio)
# Why does geojson_write change marker-color to marker.color?
geojson_write(filtered_df, lat = "latitude", lon = "longitude", file = "points.geojson")
