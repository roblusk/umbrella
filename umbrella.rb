pp "Where are you?"

# address = gets.chomp()

address = "New York"
# Replace spaces with "%20" to prepare the request for the HTTP request
address = address.strip
address = address.gsub(" ", "%20")

pp "You are at " + address

gmaps_key = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{gmaps_key}"

require "http"


