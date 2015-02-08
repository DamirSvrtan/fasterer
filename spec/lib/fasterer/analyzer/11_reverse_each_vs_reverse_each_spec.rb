require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '11_reverse_each_vs_reverse_each', 'main.rb') }

  it 'should detect a for loop' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.error_occurrence[:reverse_each_vs_reverse_each]).to eq(2)
  end
end
