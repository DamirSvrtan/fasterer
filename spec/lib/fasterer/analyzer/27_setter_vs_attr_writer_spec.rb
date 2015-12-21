require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '27_setter_vs_attr_writer.rb') }

  it 'should detect 2 setters' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:setter_vs_attr_writer].count).to eq(2)
  end
end
