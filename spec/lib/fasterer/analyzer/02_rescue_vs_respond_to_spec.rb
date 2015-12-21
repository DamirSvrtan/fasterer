require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '02_rescue_vs_respond_to.rb') }

  it 'should detect rescue NoMethodError' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:rescue_vs_respond_to].count).to eq(3)
  end
end
