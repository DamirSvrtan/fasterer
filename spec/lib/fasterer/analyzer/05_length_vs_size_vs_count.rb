require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '05_length_vs_size_vs_count.rb') }

  it 'should detect a count and size' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:length_vs_size_vs_count].count).to eq(1)
  end
end
