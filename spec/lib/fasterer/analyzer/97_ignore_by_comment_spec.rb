require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '97_ignore_by_comment.rb') }

  it 'should ignore offense if commend preceding def includes offense name' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors.count).to eq(1)
  end
end
