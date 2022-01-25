require 'spec_helper'

describe Fasterer::Analyzer do
  include FileHelper

  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '100_inline_speedups_spec.rb') }
  let!(:base_file_content) { File.read(test_file_path) }
  let(:analyzer) { Fasterer::Analyzer.new(test_file_path) }

  after { write_file(test_file_path, base_file_content) }

  context 'disable speedup by inline comment' do
    let(:speedup_file_path) { RSpec.root.join('support', 'analyzer', '08_for_loop_vs_each.rb') }
    let(:disable_speedup_comment) { '# fasterer:disable for_loop_vs_each' }

    before do
      content = File.read(speedup_file_path)
      write_file(test_file_path, "#{disable_speedup_comment}\n#{content}")
      analyzer.scan
    end

    it "shouldn't detect a for loop error" do
      expect(analyzer.errors[:for_loop_vs_each].count).to be_zero
    end
  end
end