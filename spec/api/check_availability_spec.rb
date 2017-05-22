require 'spec_helper'

describe Exlibris::Alma::Api do
  context '.check_availability' do
    recording_mode = (ENV['RECORDING_OVERRIDE'] || :new_episodes).to_sym
    let(:inst) { described_class.new api_key, base_url }
    let(:api_key) { 'l7xxe0a2a71a893845f3a0efb71980656422' }
    let(:base_url) { 'https://api-eu.hosted.exlibrisgroup.com' }

    let(:mms_id) { '99238241500561' }

    # Alma sandbox mms_id's
    # ["9911039600000561", "9922519930000561", "9922519950000561", "9922519990000561", "99238241500561",
    # "99240241500561", "99256541500561", "99257839800561", "99261241100561", "99262040600561",
    # "99270041300561", "99263840800561"]

    subject { inst.check_availability mms_id }
    it 'should return bib', vcr: { cassette_name: 'api/check_availability/exists', record: recording_mode } do
      expect(subject).to eq 'mms_id' => '99238241500561',
                            'record_format' => 'dc',
                            'linked_record_id' => { 'value' => nil, 'type' => nil },
                            'title' => '1234 test',
                            'author' => nil,
                            'issn' => nil,
                            'isbn' => nil,
                            'holdings' =>
                              { 'value' => nil,
                                'link' => 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/bibs/99238241500561/'\
                                  'holdings' },
                            'created_by' => 'exl_support',
                            'created_date' => '2016-09-07Z',
                            'last_modified_by' => 'exl_support',
                            'last_modified_date' => '2016-09-07Z',
                            'suppress_from_publishing' => 'false',
                            'anies' =>
                              ["<?xml version=\"1.0\" encoding=\"UTF-16\"?>\n<record xmlns:dc=\"http://purl.org"\
                                '/dc/elements/1.1/"><dc:title xml:lang="eng">1234 test</dc:title></record>'],
                            'link' => nil
    end

    context 'unexists mms_id' do
      let(:mms_id) { '99238241500560' }

      it 'should return bib', vcr: { cassette_name: 'api/check_availability/unexists', record: recording_mode } do
        expect { subject }.to output(/Input parameters mmsId \d+ is not valid/).to_stdout_from_any_process
        expect(subject).to be_nil
      end
    end

    context 'incorrect mms_id' do
      let(:mms_id) { 'incorrect_mms_id' }

      it 'should return bib',
         vcr: { cassette_name: 'api/check_availability/incorrect_mms_id', record: recording_mode } do
        expect { subject }.to output(/Input parameters mmsId \w+ is not valid/).to_stdout_from_any_process
        expect(subject).to be_nil
      end
    end
  end
end
