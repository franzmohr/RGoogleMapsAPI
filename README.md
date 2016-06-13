# RGoogleMapsAPI
The function maps() uses the Google Maps Distance Matrix API to download the distance and the duration of a travel between two given places.

It takes a data frame as input which contains the place of departure in the first column and the respective destination in the second. It is also possible to specify the mode of travel, i.e. if the journey is conducted by car, foot, bicycle or public transport.

The function requires the "rjson" package.
