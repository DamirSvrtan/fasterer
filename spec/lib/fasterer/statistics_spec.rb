require 'spec_helper'

describe Fasterer::Statistics do
  let(:traverser_mock) do
    traverser = OpenStruct.new
    traverser.scannable_files = []
    traverser.offenses_total_count = 0
    traverser.parse_error_paths = []
    traverser
  end

  let(:statistics) { Fasterer::Statistics.new(traverser_mock) }

  describe 'inspected_files_output' do
    it 'should be green' do
      expect(statistics.inspected_files_output)
        .to eq("\e[32m0 files inspected\e[0m")
    end
  end
end