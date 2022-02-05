require 'spec_helper'

describe Fasterer::Analyzer do
  include FileHelper
  include_context 'isolated environment'

  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '100_inline_speedups_spec.rb') }
  let!(:base_file_content) { File.read(test_file_path) }
  let(:analyzer) { Fasterer::Analyzer.new(test_file_path) }
  let(:included_speedup_file_content) { File.read(speedup_file_path) }
  let(:new_test_file_content) { '' }

  after { write_file(test_file_path, base_file_content) }

  context 'disable speedup by comment' do
    let(:speedup_file_path) { RSpec.root.join('support', 'analyzer', '08_for_loop_vs_each.rb') }
    let(:disable_speedup_comment) { '# fasterer:disable for_loop_vs_each' }

    before do
      write_file(test_file_path, "#{disable_speedup_comment}\n#{included_speedup_file_content}")
      analyzer.scan
    end

    it "shouldn't detect a for loop error" do
      expect(analyzer.errors[:for_loop_vs_each].count).to be_zero
    end
  end

  context 'with config file' do
    let(:speedup_file_path) { RSpec.root.join('support', 'analyzer', '15_keys_each_vs_each_key.rb') }
    let(:speedup) { 'keys_each_vs_each_key' }
    let(:file_traverser) { Fasterer::FileTraverser.new(test_file_path) }
    let(:config_file_content) do
      "speedups:\n"\
        "  #{speedup}: false"
    end

    let(:disable_speedup_comment) { "# fasterer:disable #{speedup}" }
    let(:enable_speedup_comment) { "# fasterer:enable #{speedup}" }

    before do
      allow_any_instance_of(Fasterer::FileTraverser).to receive(:output).and_return(nil)
      create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                  config_file_content)
      write_file(test_file_path, new_test_file_content)
      file_traverser.traverse
    end

    context 'enable by comment ignored speedup' do
      let(:new_test_file_content) do
        "#{enable_speedup_comment}\n"\
        "#{included_speedup_file_content}"
      end

      it 'detects an offense with disable speedup in config' do
        expect(file_traverser.config.ignored_speedups).to include(speedup.to_sym)
        expect(file_traverser.offenses_total_count).not_to be_zero
      end

      context 'nothing to match' do
        let(:new_test_file_content) do
          "#{included_speedup_file_content}\n"\
          "#{enable_speedup_comment}"
        end

        it 'should not detects an errors' do
          expect(file_traverser.offenses_total_count).to be_zero
        end
      end

      context 'enable comment match only in own context' do
        let(:new_test_file_content) do
          "#{disable_speedup_comment}\n"\
          "#{included_speedup_file_content}\n"\
          "#{enable_speedup_comment}\n"\
          "#{included_speedup_file_content}"
        end

        it 'detects an offense' do
          expect(file_traverser.offenses_found?).to be true
          expect(file_traverser.offenses_total_count).not_to be_zero
        end
      end
    end

    context 'overriding config' do
      let(:config_file_content) do
        "speedups:\n"\
        "  #{speedup}: true"
      end

      let(:new_test_file_content) do
        "#{disable_speedup_comment}\n"\
        "#{included_speedup_file_content}"
      end

      it 'should not detects an errors' do
        expect(file_traverser.offenses_total_count).to be_zero
      end
    end

    context 'same with config' do
      context 'both disable' do
        let(:new_test_file_content) do
          "#{disable_speedup_comment}\n"\
          "#{included_speedup_file_content}"
        end

        it 'should not detect an error' do
          expect(file_traverser.offenses_total_count).to be_zero
        end
      end

      context 'both enable' do
        let(:config_file_content) do
          "speedups:\n"\
        "  #{speedup}: true"
        end

        let(:new_test_file_content) do
          "#{enable_speedup_comment}\n"\
          "#{included_speedup_file_content}"
        end

        it 'should detects an error' do
          expect(file_traverser.offenses_total_count).not_to be_zero
        end
      end
    end
  end

  context 'multiple speedup comments in one file' do
    let(:speedup_file_path) { RSpec.root.join('support', 'analyzer', '06_shuffle_first_vs_sample.rb') }

    context 'enable disabled speedup' do
      let(:disable_speedup_comment) { '# fasterer:disable shuffle_first_vs_sample' }
      let(:enable_speedup_comment) { '# fasterer:enable shuffle_first_vs_sample' }

      before do
        write_file(test_file_path, new_test_file_content)
        analyzer.scan
      end

      context 'after inline enable comment nothing to match' do
        let(:new_test_file_content) do
          "#{disable_speedup_comment}\n"\
          "#{included_speedup_file_content}\n"\
          "#{enable_speedup_comment}"
        end

        it "shouldn't detect an error" do
          expect(analyzer.errors[:shuffle_first_vs_sample].count).to be_zero
        end
      end

      context 'disabled comment match only under disabled section' do
        let(:new_test_file_content) do
          "#{disable_speedup_comment}\n"\
          "#{included_speedup_file_content}\n"\
          "#{enable_speedup_comment}\n"\
          "#{included_speedup_file_content}"
        end
        let(:disabled_speedup) { analyzer.inline_speedup_scanner.instance_variable_get('@store')['disable'].first }
        let(:enabled_speedup) { analyzer.inline_speedup_scanner.instance_variable_get('@store')['enable'].first }

        it 'should detect an error only once' do
          expect(disabled_speedup[:context].last).to eql enabled_speedup[:context].first
          expect(analyzer.errors[:shuffle_first_vs_sample].count).to eql 5
        end
      end

      context 'same comment' do
        let(:new_test_file_content) do
          "#{disable_speedup_comment}\n"\
          "#{included_speedup_file_content}\n"\
          "#{disable_speedup_comment}\n"\
          "#{included_speedup_file_content}"
        end
        let(:disable_speedups) { analyzer.inline_speedup_scanner.instance_variable_get('@store')['disable'] }

        it 'counts only first disable comment' do
          expect(disable_speedups.count).to eql 1
          expect(disable_speedups.first[:context].first).to eql 1
        end
      end
    end
  end

  context 'inline speedup comments' do
    let(:speedup_file_path) { RSpec.root.join('support', 'analyzer', '16_hash_merge_bang_vs_hash_brackets.rb') }
    let(:offense_name) { 'hash_merge_bang_vs_hash_brackets' }
    let(:disable_speedup_comment) { "# fasterer:disable #{offense_name}" }
    let(:enable_speedup_comment) { "# fasterer:enable #{offense_name}" }
    let(:inline_speedup_store) { analyzer.inline_speedup_scanner.instance_variable_get('@store') }
    let(:file_lines) { included_speedup_file_content.split("\n") }

    before do
      write_file(test_file_path, new_test_file_content)
      analyzer.scan
    end

    context 'disable speedup in same line as offense' do
      let(:comment_line) { 17 }
      let(:new_test_file_content) do
        file_lines[comment_line - 1] += " #{disable_speedup_comment}"
        file_lines.join "\n"
      end

      it 'includes statement with comment' do
        expect(inline_speedup_store['disable'].first[:context].first).to eql comment_line
      end

      it 'detects an offense before comment line' do
        expect(analyzer.errors[offense_name.to_sym].last.line_number).to be < comment_line
      end
    end

    context 'multiple comments in file' do
      let(:disable_comment_line) { 10 }
      let(:enable_comment_line) { 17 }
      let(:new_test_file_content) do
        file_lines[disable_comment_line - 1] += " #{disable_speedup_comment}"
        file_lines[enable_comment_line - 1] += " #{enable_speedup_comment}"
        file_lines.join "\n"
      end

      it 'has first offense in comment line' do
        expect(analyzer.errors[offense_name.to_sym].first.line_number).to eql enable_comment_line
      end
    end
  end
end