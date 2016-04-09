# Gifanator
==============

#### Live site: http://gifanator.com

#### What does this app do?
Lets you send an receive animated GIFs by phone.

#### APIs used:
* [Twilio](http://www.twilio.com)  
* [Giphy](https://github.com/giphy/GiphyAPI)

#### Detailed scenarios this app handles:
**Scenario 1:** User text "random" or "Random" to **858-224-9485** and gets a random GIF.

**Scenario 2:** User text "random" or "Random" with a 10-digit number to **858-224-9485**, app will send a random GIF to that number.

**Scenario 3:** User text a search term with a 10-digit number to **858-224-9485**, app will send GIF to that number.

**Scenario 4:** User text a search term without a number to **858-224-9485**, app will send GIF to user.

**Scenario 5:** If there are no results for the search term, app will return an error message with funny GIF.
