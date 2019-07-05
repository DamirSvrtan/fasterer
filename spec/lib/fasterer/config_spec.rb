require 'spec_helper'
require 'pathname'

describe Fasterer::Config do
  let(:root) { Pathname.new("#{File.dirname(__FILE__)}/../../..").cleanpath }
  let(:expected_location) { "#{root}/.fasterer.yml" }

  describe '#file_location' do
    it 'returns a file that is in the current dir (eg the project root)' do
      expect(described_class.new.file_location).to eq(expected_location)
    end

    it 'returns a file in an ancestor dir' do
      Dir.chdir("#{root}/spec/lib") do
        expect(described_class.new.file_location).to eq(expected_location)
      end
    end

    it 'returns nil when there is no ancestor file' do
      Dir.tmpdir do
        expect(described_class.new.file_location).to be nil
      end
    end
  end
end
