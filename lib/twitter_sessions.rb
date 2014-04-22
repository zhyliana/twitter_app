require 'launchy'
require 'oauth'
require 'yaml'
require 'json'
require 'addressable/uri'

api_key = nil
begin
  api_key = File.read('.api_key').chomp
rescue
  puts "Unable to read '.api_key'. Please provide a valid Google API key."
  exit
end

CONSUMER_KEY =  File.read('.api_key')
CONSUMER_SECRET = File.read('.api_secret')
CONSUMER = OAuth::Consumer.new(
  CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

TOKEN_FILE = "access_token.yml"

class TwitterSession

  def self.get(path, query_values)
    api_url = path_to_url(path, query_values)
    response = access_token.get(api_url).body
    response_json = JSON.parse(response)

    response_json.each do |response|
      puts response["text"]
    end
  end

  def self.post(path, post_values)
    api_url = path_to_url(path, post_values)

    access_token.post(api_url)
  end

  def self.access_token
    if File.exist?(TOKEN_FILE)
      File.open(TOKEN_FILE) { |f| YAML.load(f) }
    else
      request_access_token
    end
  end

  def self.request_access_token
    @access_token ||= begin
      request_token = CONSUMER.get_request_token
      authorize_url = request_token.authorize_url

      puts "Go to this URL: #{authorize_url}"
      Launchy.open(authorize_url)

      puts "Login, and type your verification code in"
      oauth_verifier = gets.chomp
      access_token = request_token.get_access_token(
        :oauth_verifier => oauth_verifier
      )

      File.open(TOKEN_FILE, "w") { |f| f.write(access_token.to_yaml) }
            access_token

      access_token
    end
  end

  def self.path_to_url(path, query_values = nil)
    api_url = Addressable::URI.new(
    :scheme => "https",
    :host =>  "api.twitter.com",
    :path => "1.1/#{path}.json",
    :query_values => query_values
    ).to_s
  end


end
