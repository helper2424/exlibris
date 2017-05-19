$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'exlibris-alma.rb'
require 'rspec/its'
require 'vcr'
require 'webmock/rspec'
require 'rspec'

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  def_co = c.default_cassette_options
  def_co[:record] = :new_episodes
  c.default_cassette_options = def_co
  c.allow_http_connections_when_no_cassette = true
end

require 'pry'
