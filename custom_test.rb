lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'exlibris.rb'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

alma = Exlibris::Alma::Api.new 'l7xxe0a2a71a893845f3a0efb71980656422', 'https://api-na.hosted.exlibrisgroup.com'

VCR.use_cassette("synopsis") do
  p alma.check_availability 99939650000541
end
