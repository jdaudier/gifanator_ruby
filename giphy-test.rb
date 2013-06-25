require 'net/http'
require 'json'
require 'sinatra'
require "awesome_print"

url = "http://api.giphy.com/v1/gifs/search?q=ryan-gosling&api_key=dc6zaTOxFJmzC&limit=1"
resp = Net::HTTP.get_response(URI.parse(url))
buffer = resp.body
ap result = JSON.parse(buffer)["data"][0]["bitly_gif_url"]