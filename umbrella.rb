# Ask the user for their location.
pp "Where are you?"


# Get and store the user’s location.
# address = gets.chomp()
address = "New York"


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
hourly = pirate_weather_parsed_response.fetch("hourly")
summary = hourly.fetch("summary") #String
data = hourly.fetch("data")


# Display the current temperature and summary of the weather for the next hour.
pp "#{address}: #{summary}, #{temperature}F"


# For each of the next twelve hours, check if the precipitation probability is greater than 10%.
data = hourly.fetch("data")

i = 0
may_rain = false
while (i < 12 && !may_rain)
  precipProbability = data[i].fetch("precipProbability")
  if precipProbability > 0.1
    pp "It may rain #{i} hours from now. (#{precipProbability * 100}% probability)"
    may_rain = true
  end
  i = i + 1
end
if may_rain
  pp "You might want to carry an umbrella!"
else
  pp "You probably won't need an umbrella today."
end
