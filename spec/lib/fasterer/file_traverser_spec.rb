require 'spec_helper'

describe Fasterer::FileTraverser do
  include FileHelper
  include_context 'isolated environment'

  describe 'config_file' do
    context 'with no config file' do
      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end

    context 'with empty config file' do
      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, '')
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end

    context 'missing exclude_paths key' do
      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    ['speedups:'])
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end

    context 'with speedups content but no exclude_paths' do
      let(:config_file_content) do
        "speedups:\n"\
        '  keys_each_vs_each_key: true'
      end

      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    config_file_content)
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns config_file with added exclude paths key' do
        expect(file_traverser.config_file)
          .to eq('speedups' => { 'keys_each_vs_each_key' => true },
                 'exclude_paths' => [])
      end
    end

    context 'with exclude_paths content but no speedups' do
      let(:config_file_content) do
        "exclude_paths:\n"\
        "  - 'spec/support/analyzer/*.rb'"
      end

      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    config_file_content)
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns config_file with added speedups key' do
        expect(file_traverser.config_file)
          .to eq('speedups' => {},
                 'exclude_paths' => ['spec/support/analyzer/*.rb'])
      end
    end

    context 'with exclude_paths and speedups content' do
      let(:config_file_content) do
        "speedups:\n"\
        "  keys_each_vs_each_key: true\n"\
        "exclude_paths:\n"\
        "  - 'spec/support/analyzer/*.rb'"
      end

      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    config_file_content)
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns config_file' do
        expect(file_traverser.config_file)
          .to eq('speedups' => { 'keys_each_vs_each_key' => true },
                 'exclude_paths' => ['spec/support/analyzer/*.rb'])
      end
    end

    context 'with empty values' do
      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    ['speedups:',
                     '',
                     'exclude_paths:'])
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end
  end

  describe 'scannable files' do
    let(:file_traverser) { Fasterer::FileTraverser.new(argument) }

    describe 'with no ARGV' do
      let(:argument) { '.' }

      context 'when no files in folder' do
        it 'returns empty array' do
          expect(file_traverser.scannable_files).to eq([])
        end
      end

      context 'only a non-ruby file inside' do
        before do
          create_file('something.yml')
        end

        it 'returns empty array' do
          expect(file_traverser.scannable_files).to eq([])
        end
      end

      context 'a ruby file inside' do
        let(:file_name) { 'something.rb' }

        before do
          create_file(file_name)
        end

        it 'returns array with that file inside' do
          expect(file_traverser.scannable_files).to eq([file_name])
        end
      end

      context 'a ruby file inside that is ignored' do
        let(:file_name) { 'something.rb' }

        let(:config_file_content) do
          "exclude_paths:\n"\
          "  - '#{file_name}'"
        end

        before(:each) do
          create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                      config_file_content)

          create_file(file_name)
        end

        it 'returns empty array' do
          expect(file_traverser.scannable_files).to eq([])
        end
      end

      context 'a ruby file inside that is not ignored' do
        let(:file_name) { 'something.rb' }

        let(:config_file_content) do
          "exclude_paths:\n"\
          "  - 'sumthing.rb'"
        end

        before(:each) do
          create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, config_file_content)
          create_file(file_name)
        end

        it 'returns empty array' do
          expect(file_traverser.scannable_files).to eq([file_name])
        end
      end

      context 'nested ruby files' do
        before(:each) do
          create_file('something.rb')
          create_file('nested/something.rb')
        end

        it 'returns files properly' do
          expect(file_traverser.scannable_files)
            .to match_array(['something.rb', 'nested/something.rb'])
        end
      end

      context 'ruby files but nested ignored explicitly' do
        let(:config_file_content) do
          "exclude_paths:\n"\
          "  - 'nested/something.rb'"
        end

        before(:each) do
          create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, config_file_content)
          create_file('something.rb')
          create_file('nested/something.rb')
        end

        it 'returns unignored files' do
          expect(file_traverser.scannable_files)
            .to match_array(['something.rb'])
        end
      end

      context 'ruby files but nested ignored with *' do
        let(:config_file_content) do
          "exclude_paths:\n"\
          "  - 'nested/*'"
        end

        before(:each) do
          create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, config_file_content)
          create_file('something.rb')
          create_file('nested/something.rb')
        end

        it 'returns unignored files' do
          expect(file_traverser.scannable_files)
            .to match_array(['something.rb'])
        end
      end

      context 'ruby files but unnested ignored' do
        let(:config_file_content) do
          "exclude_paths:\n"\
          "  - 'something.rb'"
        end

        before(:each) do
          create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, config_file_content)
          create_file('something.rb')
          create_file('nested/something.rb')
        end

        it 'returns unignored files' do
          expect(file_traverser.scannable_files).to match_array(['nested/something.rb'])
        end
      end
    end

    describe 'with one file argument' do
      let(:argument) { 'something.rb' }

      context 'and no config file' do
        before do
          create_file('something.rb')
        end

        it 'returns that file' do
          expect(file_traverser.scannable_files).to match_array([argument])
        end
      end

      context 'and config file ignoring it' do
        let(:config_file_content) do
          "exclude_paths:\n"\
          "  - 'something.rb'"
        end

        before do
          create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, config_file_content)
          create_file('something.rb')
        end

        it 'returns empty array' do
          expect(file_traverser.scannable_files).to match_array([])
        end
      end
    end

    describe 'with one folder argument' do
      let(:argument) { 'nested/' }

      let(:file_names) { ['nested/something.rb', 'nested/something_else.rb'] }

      context 'and no config file' do
        before do
          file_names.each { |file_name| create_file(file_name) }
        end

        it 'returns those files' do
          expect(file_traverser.scannable_files).to match_array(file_names)
        end
      end

      context 'and config file ignoring it' do
        let(:config_file_content) do
          "exclude_paths:\n"\
          "  - 'nested/*'"
        end

        before do
          create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, config_file_content)
          file_names.each { |file_name| create_file(file_name) }
        end

        it 'returns empty array' do
          expect(file_traverser.scannable_files).to match_array([])
        end
      end
    end
  end

  describe 'parse errors' do
    before do
      create_file('user.rb', '[]*/sa*()')
      file_traverser.traverse
    end

    let(:file_traverser) { Fasterer::FileTraverser.new('.') }

    it 'should have errors' do
      expect(file_traverser.parse_error_paths.first)
        .to start_with('user.rb - RubyParser::SyntaxError - unterminated')
    end
  end

  describe 'output' do
    let(:test_file_path) { RSpec.root.join('support', 'output', 'sample_code.rb') }
    let(:analyzer) { Fasterer::Analyzer.new(test_file_path) }
    let(:file_traverser) { Fasterer::FileTraverser.new('.') }

    before do
      analyzer.scan
    end

    context "when print offenses" do
      let(:explanation) { Fasterer::Offense::EXPLANATIONS[:for_loop_vs_each] }

      it 'should print offense' do
        match = "\e[31m#{test_file_path}:1\e[0m #{explanation}.\n\n"

        expect { file_traverser.send(:output, analyzer) }.to output(match).to_stdout
      end
    end
  end
end
