require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'net/http'
require 'json'
# require "awesome_print"

#If using local tunnel
# set :port, 8000
#Make sure local port matches local tunnel port 8000
#Make sure local server is running before creating a local tunnel 

account_sid = ENV['ACCOUNT_SID'] 
auth_token = ENV['AUTH_TOKEN']
client = Twilio::REST::Client.new account_sid, auth_token

get '/twilio2' do
  search_term = params[:Body] 
  #App won't work unless you pass in the search params. 
  #For instance: http://58x5.localtunnel.com/twilio2?Body=channing 
  
  return "Please specify a search term." if params[:Body].nil?

  url = "http://api.giphy.com/v1/gifs/search?q=#{search_term.gsub("\n", '')}&api_key=dc6zaTOxFJmzC&limit=1"
  resp = Net::HTTP.get_response(URI.parse(url))
  buffer = resp.body
  result = JSON.parse(buffer)["data"][0]["bitly_gif_url"]
  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms "Click the link for your animated gif! #{result}"
  end
  twiml.text
end

