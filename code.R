library(ecoengine)
library(dplyr)
library(wesanderson)

# This is an example query that gets 1000 observations
x <- ee_observations(genus = "vulpes", georeferenced = TRUE)
# Get unique species so we can add colors
unique_species <- x$data %>% group_by(scientific_name) %>% summarise(n = n()) %>% arrange(desc(n))
pal <- wes_palette("Zissou", 100, type = "continuous")
colors <- pal[1:nrow(unique_species)]
unique_species$marker_color <- colors

filtered_df <- left_join(x$data, unique_species, by = "scientific_name")
filtered_df <- filtered_df %>% select(scientific_name, begin_date, marker_color, latitude, longitude)

head(filtered_df)

