require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

#Make sure local port matches local tunnel port 8000
#Make sure local server is running before creating a local tunnel 

account_sid = ENV['ACCOUNT_SID'] 
auth_token = ENV['AUTH_TOKEN']
client = Twilio::REST::Client.new account_sid, auth_token

set :port, 8000

get '/twilio2' do
  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms "Hey Monkey. Thanks for the message!"
  end
  twiml.text
end