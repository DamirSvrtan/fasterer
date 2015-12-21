require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '15_keys_each_vs_each_key.rb') }

  it 'should detect keys each 3 times' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:keys_each_vs_each_key].count).to eq(3)
  end
end
