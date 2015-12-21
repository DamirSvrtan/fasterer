require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) do
    RSpec.root.join('support', 'analyzer', '29_include_vs_cover_on_range.rb')
  end

  it 'should detect 3 include? method calls' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:include_vs_cover_on_range].count).to eq(3)
  end
end
