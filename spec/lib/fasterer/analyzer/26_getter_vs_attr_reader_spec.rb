require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '26_getter_vs_attr_reader.rb') }

  it 'should detect 2 getters' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:getter_vs_attr_reader].count).to eq(2)
  end
end
