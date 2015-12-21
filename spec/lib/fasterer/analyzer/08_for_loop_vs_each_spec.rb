require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '08_for_loop_vs_each.rb') }

  it 'should detect a for loop' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:for_loop_vs_each].count).to eq(1)
  end
end
