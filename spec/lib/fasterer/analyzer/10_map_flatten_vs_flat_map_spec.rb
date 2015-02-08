require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '10_map_flatten_vs_flat_map', 'main.rb') }

  it 'should detect a map{}.flatten(1) ' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.error_occurrence[:map_flatten_vs_flat_map]).to eq(2)
  end
end
