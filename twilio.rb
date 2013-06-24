require 'rubygems'
require 'twilio-ruby'
account_sid = ENV['ACCOUNT_SID'] 
auth_token = ENV['AUTH_TOKEN']
client = Twilio::REST::Client.new account_sid, auth_token

from = "+18582249485" # Your Twilio number

puts "What is your name?"
name = gets.chomp

puts "What is your mobile number? (Just enter a 10-digit number, no dashes or spaces)"
number = gets.chomp

students = {}
students[number] = name

puts "What funny thing did you hear at MakerSquare today?"
individual_quote = gets.chomp
all_quotes = []
all_quotes << individual_quote
 

students.each do |number, name|
  client.account.sms.messages.create(
    :from => from,
    :to => number,
    :body => "Hey #{name}, here's your MakerSquare Quote of the Day: \"#{all_quotes.sample}\""
  ) 
  puts "Sent message to #{name}"
end