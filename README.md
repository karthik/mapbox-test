
# Testing a mapbox replacement

This is an experiment to replace `leafletR` that I currently use in `ecoengine` and `AntWeb`. The leaflet map is ugly and hard to customize. This setup below is way better.

## +1s
* Nice map
* Easy to add markers and such
* Everything can be customized in a `data.frame` and written to `geojson` from `geojsonio`



## Current status

a) The map itself [works fine](http://karthik.github.io/mapbox-test/)  
b) The data are [there](https://github.com/karthik/mapbox-test/blob/master/notes.md#example-data)  
c) I've got a very ugly set up to put everything together.

## How it should work

* User runs query
* Data with lat/long + necessary fields gets written to `geojson`
* This file gets parsed or read into the html file
* `browseURL()` to that html file.

## Bottlenecks

* ~~`geojsonio` replaces `-` with `.` (Currently being cleaned by an ugly `sed`)~~ Fixed this by using `leafletR::toGeoJSON`.  
* templating also happens with an ugly system `cat`.
* Also map is randomly centered. Center map based on the lat/long based on the coords in file. 


