require 'logger'
require 'rest-client'
require 'webmock'
require 'vcr'
require 'marcus'
require 'nokogiri'

require 'exlibris/base'
require 'exlibris/alma/api'

module Exlibris
  module Alma
    BASE_URL_AMERICA = 'https://api-na.hosted.exlibrisgroup.com'.freeze
    BASE_URL_EUROPE = 'https://api-eu.hosted.exlibrisgroup.com'.freeze
    BASE_URL_ASIA_PACIFIC = 'https://api-ap.hosted.exlibrisgroup.com'.freeze
    BASE_URL_CANADA ='https://api-ca.hosted.exlibrisgroup.com'.freeze
  end
end