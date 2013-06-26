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
  # search_term = params[:Body] 
  #App won't work unless you pass in the search params. 
  #For instance: http://58x5.localtunnel.com/twilio2?Body=channing 
  
  return "Send a text message to 858-224-9485 and specify a search term." if params[:Body].nil?

#   url = "http://api.giphy.com/v1/gifs/search?q=#{search_term.gsub(' ', '-')}&api_key=dc6zaTOxFJmzC&limit=1"
#   resp = Net::HTTP.get_response(URI.parse(url))
#   buffer = resp.body
#   result = JSON.parse(buffer)["data"][0]["bitly_gif_url"]
#   twiml = Twilio::TwiML::Response.new do |r|
#     r.Sms "Click the link for your animated gif! #{result}"
#   end
#   twiml.text
# end

##Send to another user
search_term = params[:Body]

#If there's a 10-digit phone # in the text msg, store that #, and 
#send gif URL to that number.
#If there's no number, send to user.

friends_number = search_term.match(/\d{10}/).to_s #Extract phone # and turns it into a string

  if !friends_number.nil? #if there is a friend's number
    message = @client.account.sms.messages.create(:body => "Jenny please?! I love you <3",
        :to => friends_number)
    puts message.sid
  else #if there is no number
    url = "http://api.giphy.com/v1/gifs/search?q=#{search_term.gsub('friends_number', '').gsub(' ', '-')}&api_key=dc6zaTOxFJmzC&limit=1"
    resp = Net::HTTP.get_response(URI.parse(url))
    buffer = resp.body
    result = JSON.parse(buffer)["data"][0]["bitly_gif_url"]
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms "Click the link for your animated gif! #{result}"
    end
    twiml.text
  end
end


