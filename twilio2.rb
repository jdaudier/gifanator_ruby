require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'net/http'
require 'json'
# require "awesome_print"

account_sid = ENV['ACCOUNT_SID'] 
auth_token = ENV['AUTH_TOKEN']
client = Twilio::REST::Client.new account_sid, auth_token

get '/twilio2' do
  # search_term = params[:Body] 
  #App won't work unless you pass in the search params. 
  #For instance: http://58x5.localtunnel.com/twilio2?Body=channing 
  
  return "Send a text message to 858-224-9485 and specify a search term." if params[:Body].nil?

#Send to another user
search_term = params[:Body]

#If there's a 10-digit phone # in the text msg, store that #, and send gif URL to that number.
#If there's no number, send to user.

friends_number = search_term.match(/\d{10}/).to_s #Extract phone # and turns it into a string
url = "http://api.giphy.com/v1/gifs/search?q=#{search_term.gsub(friends_number, '').gsub(' ', '+')}&api_key=dc6zaTOxFJmzC&limit=1"
resp = Net::HTTP.get_response(URI.parse(url))
buffer = resp.body
result = JSON.parse(buffer)["data"][0]["bitly_gif_url"]

  if friends_number != "" #if friend's number is not blank
    message = client.account.sms.messages.create(:body => "Your friend just sent you an animated gif! #{result}",
        :to => friends_number,
        :from => "+18582249485")
    puts message.sid
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms "We've just sent your friend this awesome animated gif! #{result}"
    end
    twiml.text
  else #if there is no number
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms "Click the link for your animated gif! #{result}"
    end
    twiml.text
  end
end