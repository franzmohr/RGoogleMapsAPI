# RGoogleMapsAPI
The function <code>maps()</code> uses the Google Maps Distance Matrix API to download the distance (in kilometers) and the duration (in hours) of a travel between two given places. It takes a data frame as input which contains the place of departure in the first column and the respective destination in the second. It is also possible to specify the mode of travel, i.e. if the journey is conducted by car, foot, bicycle or public transport and the time of departure if "transit" is selected.

<code>gen.url()</code> generates the URL used to query data from the Google API.

The function requires the "rjson" package.

## Copyright
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
