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
#Scenario 2: User text "random" or "Random" with a 10-digit number, send random gif to that number.
#Scenario 3: User text a search term with a 10-digit number, send gif to that number.
#Scenario 4: If there's no number in the text msg, send gif to user.

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
      "http://giphy.com/gifs/#{id}"
  end

  def sendtext(reply)
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms(reply)
    end
    twiml.text
  end

  if search_term == "random"
    sendtext("Confucius says: Man who text me, gets random animated gif! #{random}")

  elsif friends_number != "" #if friend's number is not blank
    if search_term == "random"
    result = random
    message = client.account.sms.messages.create(:body => "Your friend at this number #{sender} just sent you a random animated gif! #{result}",
        :to => friends_number,
        :from => "+18582249485")
    puts message.sid
    
    sendtext("BOOM! We've just sent your friend this awesome random animated gif! #{result}")
    else
    message = client.account.sms.messages.create(:body => "Your friend at this number #{sender} just sent you an animated gif! #{result}",
        :to => friends_number,
        :from => "+18582249485")
    puts message.sid
    
    sendtext("BOOM! We've just sent your friend this awesome animated gif! #{result}")
    end
  else #if there is no number
    sendtext("Click the link for your totally awesome animated gif. Booyah! #{result}")
  end
end