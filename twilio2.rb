require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'net/http'
require 'json'
# require "awesome_print"

account_sid = ENV['ACCOUNT_SID'] 
auth_token = ENV['AUTH_TOKEN']
client = Twilio::REST::Client.new account_sid, auth_token

#Scenario 1: User text "random" or "Random" and gets a random gif.
#Scenario 2: If there's a 10-digit phone # in the text msg, send gif URL to that number.
#Scenario 3: If there's no number in the text msg, send gif to user.

get '/twilio2' do
#App won't work unless you pass in the search params. 
#For instance: http://58x5.localtunnel.com/twilio2?Body=channing 

return "Send a text message to 858-224-9485 and specify a search term. Text 'random' if you want a random gif. Add a number in your text to send to a friend." if params[:Body].nil?

  search_term = params[:Body].downcase
  sender = params[:From]

  friends_number = search_term.match(/\d{10}/).to_s #Extract phone # and turns it into a string
  url = "http://api.giphy.com/v1/gifs/translate?s=#{search_term.gsub(friends_number, '').gsub(' ', '+')}&api_key=dc6zaTOxFJmzC&limit=1"
  resp = Net::HTTP.get_response(URI.parse(url))
  buffer = resp.body
  result = JSON.parse(buffer)["data"]["bitly_gif_url"]

  def random
      url = "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC"
      resp = Net::HTTP.get_response(URI.parse(url))
      buffer = resp.body
      id = JSON.parse(buffer)["data"]["id"]
      result = "http://giphy.com/gifs/#{id}"
      results
  end

  if search_term == "random"
    random
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms "Confucius says: Man who text me, gets random animated gif! #{result}"
    end
    twiml.text
  elsif friends_number != "" #if friend's number is not blank
    message = client.account.sms.messages.create(:body => "Your friend at this number #{sender} just sent you an animated gif! #{result}",
        :to => friends_number,
        :from => "+18582249485")
    puts message.sid
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms "BOOM! We've just sent your friend this awesome animated gif! #{result}"
    end
    twiml.text
  else #if there is no number
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms "Click the link for your totally awesome animated gif. Booyah! #{result}"
    end
    twiml.text
  end
end