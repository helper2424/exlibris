require 'alma'

Alma.configure do |config|
  # You have to set te apikey
  config.apikey     = 'l7xxe0a2a71a893845f3a0efb71980656422'
  # Alma gem defaults to querying Ex Libris's North American  Api servers. You can override that here.
  config.region   = 'https://api-na.hosted.exlibrisgroup.com'
end

users = Alma::User.find

p users.total count