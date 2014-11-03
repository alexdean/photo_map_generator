# Photo Map Generator

I use this script to generate a photo map from a combination of GPS data and
photos I've taken. The script is here as a reference. It's not usable as-is,
but could probably be packaged as a gem at some point.

You can see [a live example](https://www.deanspot.org/alex/2014/11/01/st-ignace-island.html) on my blog.

## Outline

  1. Extract the creation time from each photo.
  1. Use GPS data to figure out where I was at the time the photo was taken.
  1. Add each located photo to the map.
  1. Draw a line for each segment (day) of GPS data.

## Complications

Getting good locations from photos using this method can be tough. If your camera's
clock is wrong (and when is the last time you checked, really?), you'll get incorrect
locations. Manually adjusting those dates is possible, but maddening.

When GPS data is missing (because the unit was off), you have a few options.
Guess a location by interpolating from existing GPS data. This works OK if the
period of missing data isn't too large. Otherwise, you might be better off using
something like Google Earth to manually find the right location for your photo.
This script doesn't yet support any kind of manual per-photo location adjustments,
but it's on the TODO list.

If you want to make maps like this, you'll get the best results if you set your
camera's clock from the GPS unit, and leave the GPS unit on whenever you might be
using the camera. All of the headaches I've had stem from the failure to do one of
these two things.

## Libraries Used

  - [exifr](https://github.com/remvee/exifr/) is used by my photo gallery to extract time information from photos
  - [where_was_i](https://github.com/alexdean/where_was_i) returns a location (from GPS data) based on the times extracted from photos.
  - [leaflet.js](http://leafletjs.com) is the main mapping library.
  - [Leaflet.Photo](https://github.com/turban/Leaflet.Photo) makes it really easy to generate nice-looking photo maps.
  - [leaflet-plugins](https://github.com/shramov/leaflet-plugins) allows the usage of Google Maps on a leaflet map.
  - [Leaflet.markercluster](https://github.com/Leaflet/Leaflet.markercluster) groups nearby points together on the map, and expands the clusters when you zoom in.
  - I use [httparty](https://github.com/jnunemaker/httparty) and [httparty-cookies](https://github.com/mkroman/httparty-cookies) to fetch photo data from my personal image gallery.
