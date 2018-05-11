require 'spec_helper'
require 'pathname'

describe Fasterer::Config do
  ROOT = Pathname.new("#{File.dirname(__FILE__)}/../../..").cleanpath
  EXPECTED_LOCATION = "#{ROOT}/.fasterer.yml"

  describe 'file_location' do
    it 'when the file is in the current dir (the project root)' do
      expect(described_class.new.file_location).to eq(EXPECTED_LOCATION)
    end

    it 'when the file is in an ancestor dir' do
      Dir.chdir("#{ROOT}/spec/lib") do
        expect(described_class.new.file_location).to eq(EXPECTED_LOCATION)
      end
    end
  end
end
