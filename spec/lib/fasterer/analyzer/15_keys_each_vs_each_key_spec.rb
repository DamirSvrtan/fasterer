require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '15_keys_each_vs_each_key', 'main.rb') }

  it 'should detect keys each 3 times' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.error_occurrence[:keys_each_vs_each_key]).to eq(3)
  end
end
