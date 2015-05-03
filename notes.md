---
title: "Testing a new Mapbox map"
author: "Karthik Ram"
date: "May 2, 2015"
output: html_document
---


```r
library(ecoengine)
library(dplyr)
library(wesanderson)
library(pander)
```




```r
# This is an example query that gets 1000 observations
x <- ee_observations(genus = "vulpes", georeferenced = TRUE, quiet = TRUE, progress = FALSE)
# Get unique species so we can add colors
unique_species <- x$data %>% group_by(scientific_name) %>% summarise(n = n()) %>% arrange(desc(n))
pal <- wes_palette("Zissou", 100, type = "continuous")
colors <- pal[1:nrow(unique_species)]
unique_species$marker_color <- colors
filtered_df <- left_join(x$data, unique_species, by = "scientific_name")
filtered_df <- filtered_df %>% select(scientific_name, begin_date, marker_color, latitude, longitude)
```

# Example Data


|   &nbsp;   |     scientific_name     |  begin_date  |  marker_color  |  latitude  |  longitude  |
|:----------:|:-----------------------:|:------------:|:--------------:|:----------:|:-----------:|
|   **1**    | Vulpes macrotis arsipus |  1935-03-23  |    #429DB4     |   33.02    |   -114.6    |
|   **2**    | Vulpes macrotis arsipus |  1942-02-22  |    #429DB4     |   34.76    |   -116.4    |
|   **3**    | Vulpes macrotis arsipus |  1947-09-11  |    #429DB4     |   32.73    |   -114.7    |
|   **4**    | Vulpes macrotis arsipus |  1947-09-11  |    #429DB4     |   32.73    |   -114.7    |
|   **5**    | Vulpes macrotis arsipus |  1947-09-12  |    #429DB4     |   32.73    |   -114.7    |
|   **6**    | Vulpes macrotis arsipus |  1947-09-14  |    #429DB4     |   32.73    |   -114.7    |
|  **995**   |      Vulpes vulpes      |  1996-06-17  |    #3D9BB2     |   37.46    |   -122.1    |
|  **996**   | Vulpes macrotis mutica  |  1984-01-26  |    #3B9AB2     |   35.25    |   -119.5    |
|  **997**   |      Vulpes vulpes      |  2001-01-29  |    #3D9BB2     |   37.57    |   -122.1    |
|  **998**   |      Vulpes vulpes      |  1997-03-09  |    #3D9BB2     |    37.5    |   -122.2    |
|  **999**   | Vulpes macrotis mutica  |  1989-09-08  |    #3B9AB2     |   35.27    |   -119.5    |
|  **1000**  | Vulpes macrotis mutica  |  1991-03-07  |    #3B9AB2     |   35.72    |   -120.8    |

