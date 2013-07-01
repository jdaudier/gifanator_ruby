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
#Scenario 5: If there are no results for the search term, return error msg with funny gif. 

get '/' do
#App won't work unless you pass in the search params. 
#For instance: http://58x5.localtunnel.com/twilio2?Body=channing 

  return "Send a text message to 858-224-9485 and specify a search term. Text 'random' if you want a random gif. Add a number in your text to send to a friend." if params[:Body].nil?

  search_term = params[:Body].downcase
  sender = params[:From]

  friends_number = search_term.match(/\d{10}/).to_s #Extract phone # and turns it into a string
  url = "http://api.giphy.com/v1/gifs/translate?s=#{search_term.gsub(friends_number, '').gsub(' ', '+')}&api_key=dc6zaTOxFJmzC&limit=1"
  resp = Net::HTTP.get_response(URI.parse(url))
  buffer = resp.body

  def sendtext(reply)
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms(reply)
    end
    twiml.text
  end

  def random
    url = "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC"
    resp = Net::HTTP.get_response(URI.parse(url))
    buffer = resp.body
    id = JSON.parse(buffer)["data"]["id"]
    "http://giphy.com/gifs/#{id}"
  end

  if JSON.parse(buffer)["data"].empty?
    message = client.account.sms.messages.create(:body => "What what? Who would search for that? Sorry, no results found! http://gph.is/XIjPNh",
        :to => sender,
        :from => "+18582249485")
    puts message.sid
  else
    result = JSON.parse(buffer)["data"]["bitly_gif_url"]
    if search_term == "random"
      sendtext("Confucius says: Man who texts me, gets random animated gif! #{random}")

    elsif friends_number != "" #if friend's number is not blank
      if search_term.include? "random"
      result = random
      message = client.account.sms.messages.create(:body => "Your friend at this number #{sender} just sent you a RANDOM animated gif! #{result}",
          :to => friends_number,
          :from => "+18582249485")
      puts message.sid
      
      sendtext("NICE! We've just sent your friend this awesome RANDOM animated gif! #{result}")
      else
      message = client.account.sms.messages.create(:body => "Your friend at this number #{sender} just sent you an awesome animated gif! Well, aren't we special? #{result}",
          :to => friends_number,
          :from => "+18582249485")
      puts message.sid
      
      sendtext("BOOM! We've just sent your friend this awesome animated gif! #{result}")
      end

    else #if there is no number
      sendtext("Click the link for your totally awesome animated gif. Booyah! #{result}")
    end
  end
end