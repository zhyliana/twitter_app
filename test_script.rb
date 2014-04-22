require 'launchy'
require 'oauth'

# "Consumer" in Twitter terminology means "client" in our discussion.
# God only knows who thought it was a good idea to make up many terms
# for the same thing.
CONSUMER_KEY = '01O9eE6hukpGRdEJdwUiaWbvB'
CONSUMER_SECRET = "PRaJ0VumeGVphLVMKn1JsMrcCjAdt8lrhiq0SaQx4083Sgzoq7"

# An `OAuth::Consumer` object can make requests to the service on
# behalf of the client application.
CONSUMER = OAuth::Consumer.new(
  CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

# Ask service for a URL to send the user to so that they may authorize
# us.
request_token = CONSUMER.get_request_token
authorize_url = request_token.authorize_url

# Launchy is a gem that opens a browser tab for us
puts "Go to this URL: #{authorize_url}"
Launchy.open(authorize_url)

# Because we don't use a redirect URL; user will receive a short PIN
# (called a **verifier**) that they can input into the client
# application. The client asks the service to give them a permanent
# access token to use.
puts "Login, and type your verification code in"
oauth_verifier = gets.chomp
access_token = request_token.get_access_token(
  :oauth_verifier => oauth_verifier
)

# The `OAuth::AccessToken` object lets us make HTTP requests on behalf
# of the user. It has the same methods as restclient. Unlike
# restclient, requests made using this token will also include the
# client keys and the user's access token, so that the service can
# make sure the request is properly authorized.
response = access_token
  .get("https://api.twitter.com/1.1/statuses/user_timeline.json")
  .body

puts response