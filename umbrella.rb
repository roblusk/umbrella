# Ask the user for their location.
pp "Where are you?"


# Get and store the user’s location.
address = gets.chomp()


# Get the user’s latitude and longitude from the Google Maps API.
address = address.strip # Remove excess spaces
address_encoded = address.gsub(" ", "%20") # Replace spaces with "%20" to prepare the request for the HTTP request

# Construct HTTP request
gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address_encoded}&key=#{gmaps_key}"
require "http"
gmaps_raw_response = HTTP.get(gmaps_url)
gmaps_parsed_response = JSON.parse(gmaps_raw_response)
results = gmaps_parsed_response.fetch("results")
first_result = results[0]
geometry = first_result.fetch("geometry")
location = geometry.fetch("location")
lat = location.fetch("lat") #Float
lng = location.fetch("lng") #Float

# Get the weather at the user’s coordinates from the Pirate Weather API.
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"
pirate_weather_raw_response = HTTP.get(pirate_weather_url)
pirate_weather_parsed_response = JSON.parse(pirate_weather_raw_response)
currently = pirate_weather_parsed_response.fetch("currently")
temperature = currently.fetch("temperature") #Float
pp "The temperature at #{address} is #{temperature}F"

