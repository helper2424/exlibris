require 'spec_helper'

describe Exlibris::Alma::Api do
  context '.holding_items' do
    recording_mode = (ENV['RECORDING_OVERRIDE'] || :new_episodes).to_sym
    vcr_path = 'api/holdings_items/'
    let(:inst) { described_class.new api_key, base_url }
    let(:api_key) { 'l7xxe0a2a71a893845f3a0efb71980656422' }
    let(:base_url) { 'https://api-eu.hosted.exlibrisgroup.com' }

    let(:mms_id) { '99238241500561' }
    let(:holding_id) { '1' }

    # Alma sandbox mms_id's
    # ["9911039600000561", "9922519930000561", "9922519950000561", "9922519990000561", "99238241500561",
    # "99240241500561", "99256541500561", "99257839800561", "99261241100561", "99262040600561",
    # "99270041300561", "99263840800561"]

    subject { inst.holding_items mms_id, holding_id }
    it 'should return items for holding', vcr: { cassette_name: "#{vcr_path}exists", record: recording_mode } do
      expect(subject).to eq 'total_record_count' => 0
    end

    context 'unexists mms_id' do
      let(:mms_id) { '992382415005' }

      it 'should return nothing', vcr: { cassette_name: "#{vcr_path}unexists_mms_id", record: recording_mode } do
        expect(subject).to eq 'total_record_count' => 0
      end
    end

    context 'empty mms_id' do
      let(:mms_id) {}

      it 'should raise error', vcr: { cassette_name: "#{vcr_path}empty_mms_id", record: recording_mode } do
        expect { subject }.to output(/NOT_FOUND/).to_stdout_from_any_process
        expect(subject).to be_nil
      end
    end

    context 'empty holding_id' do
      let(:holding_id) {}

      it 'should raise error', vcr: { cassette_name: "#{vcr_path}empty_holding_id", record: recording_mode } do
        expect { subject }.to output(/NOT_FOUND/).to_stdout_from_any_process
        expect(subject).to be_nil
      end
    end
  end
end
