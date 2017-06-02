lib = File.expand_path('../..', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exlibris-alma'
require 'pp'
require 'pry'

require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = './tmp_research/fixtures/vcr'
  c.hook_into :webmock
  def_co = c.default_cassette_options
  def_co[:record] = :new_episodes
  c.default_cassette_options = def_co
  c.allow_http_connections_when_no_cassette = true
end

bases = {
  na: 'https://api-na.hosted.exlibrisgroup.com',
  eu: 'https://api-eu.hosted.exlibrisgroup.com',
  ap: 'https://api-ap.hosted.exlibrisgroup.com',
  ca: 'https://api-ca.hosted.exlibrisgroup.com'
}

mms_ids = %w(9911039600000561 9922519930000561 9922519950000561 9922519990000561 99238241500561 99240241500561
             99256541500561 9257839800561 99261241100561 99262040600561 99270041300561 99263840800561)

#api_key = 'l7xxe0a2a71a893845f3a0efb71980656422'
api_key = 'l7xxe61a3ffca3d24bd7a53c60cf41b36426'

# bases.each do |k, v|
#   api_inst = Exlibris::Alma::Api.new api_key, v
#
#   collections = api_inst.__send__ :request, method: :get, url_body: 'bibs/collections'
#
#   next if collections.blank?
#   collections = Oj.load collections.body
#
#   File.open("./tmp_research/fixtures/prod_#{k}_collections.json", 'w') { |file| file.write(collections.to_json) }
#   mms_ids = (collections['collection'] || []).map { |i| i['mms_id']['value'] }
#   File.open("./tmp_research/fixtures/prod_#{k}_mms_ids.json", 'w') { |file| file.write(mms_ids.to_json) }
#
#   pp "Mms ids : #{mms_ids.join ','}"
# end

p 'Extract holdings'

mms_ids = ['21119852100001891']

bases.each do |k, v|
  api_inst = Exlibris::Alma::Api.new api_key, v

  mms_ids.each do |m|
    holdings = nil
    VCR.use_cassette("hold_#{k}_#{m}") do
      holdings = api_inst.holdings m
    end

    next if holdings.blank?
    File.open("./tmp_research/fixtures/prod_holdings/_#{k}_#{m}.json", 'w') { |file| file.write(holdings.to_json) }
    pp holdings if holdings['total_record_count'] > 0
  end
end
#
p 'Extract loans'

bases.each do |k, v|
  api_inst = Exlibris::Alma::Api.new api_key, v

  mms_ids.each do |m|
    holdings = nil
    VCR.use_cassette("loan_#{k}_#{m}") do
      holdings = api_inst.loans m
    end

    next if holdings.blank?
    File.open("./tmp_research/fixtures/prod_loans/_#{k}_#{m}.json", 'w') { |file| file.write(holdings.to_json) }
    pp holdings if holdings['total_record_count'] > 0
  end
end
