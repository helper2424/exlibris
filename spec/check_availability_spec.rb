require 'spec_helper'

describe Exlibris::Alma::Api do
  context '.check_availability' do
    recording_mode = (ENV['RECORDING_OVERRIDE'] || :new_episodes).to_sym
    let(:inst) { described_class.new api_key, base_url }
    let(:api_key) { 'l7xxe0a2a71a893845f3a0efb71980656422' }
    let(:base_url) { 'https://api-eu.hosted.exlibrisgroup.com' }

    let(:mms_id) { '99238241500561' }

    subject { inst.check_availability mms_id }
    it 'should return bib', vcr: { cassette_name: 'api/check_availability', record: recording_mode } do
      expect(subject).to eq 'created_by' => 'exl_support',
                            'created_date' => '2016-09-07Z',
                            'holdings' => '',
                            'last_modified_by' => 'exl_support',
                            'last_modified_date' => '2016-09-07Z',
                            'linked_record_id' => '',
                            'mms_id' => '99238241500561',
                            'record' => '1234 test',
                            'record_format' => 'dc',
                            'suppress_from_publishing' => 'false',
                            'title' => '1234 test'
    end
  end
end
