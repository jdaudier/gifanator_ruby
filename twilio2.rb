require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

account_sid = 'AC0f8c59269730d61d7d83cf182968a50a'
auth_token = '557cd61e8d61e32aec182e0dec900b2f'
client = Twilio::REST::Client.new account_sid, auth_token

get '/sms-quickstart' do
  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms "Hey Monkey. Thanks for the message!"
  end
  twiml.text
end