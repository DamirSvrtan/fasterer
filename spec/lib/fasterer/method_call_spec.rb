require 'spec_helper'

describe Fasterer::MethodCall do

  let(:ripper) do
    Ripper.sexp(File.read(RSpec.root.join('support', 'method_call', file_name)))
  end

  let(:method_call) do
    Fasterer::MethodCall.new(call_element)
  end

  describe 'method call on a constant' do

    let(:file_name) { 'method_call_on_constant.rb' }

    # This is where the :call token will be recognized.
    let(:call_element) { ripper.drop(1).first.first[1] }

    it 'should detect constant' do
      expect(method_call.method_name).to eq('hello')
      expect(method_call.arguments).to be_empty
    end

  end

  describe 'method call on a integer' do

    let(:file_name) { 'method_call_on_integer.rb' }

    # This is where the :call token will be recognized.
    let(:call_element) { ripper.drop(1).first.first[1] }

    it 'should detect integer' do
      expect(method_call.method_name).to eq('hello')
      expect(method_call.arguments).to be_empty
    end

  end

  describe 'method call on a string' do

    let(:file_name) { 'method_call_on_string.rb' }

    let(:call_element) { ripper.drop(1).first.first[1] }

    it 'should detect string' do
      expect(method_call.method_name).to eq('hello')
      expect(method_call.arguments).to be_empty
    end

  end

  describe 'method call on a variable' do

    let(:file_name) { 'method_call_on_variable.rb' }

    let(:call_element) { ripper.drop(1).first.last[1] }

    it 'should detect variable' do
      expect(method_call.method_name).to eq('hello')
      expect(method_call.arguments).to be_empty
      expect(method_call.receiver).to be_a(Fasterer::VariableReference)
    end

  end

  describe 'method call on a method' do

    let(:file_name) { 'method_call_on_method_call.rb' }

    let(:call_element) { ripper.drop(1).first.first[1] }

    it 'should detect method' do
      expect(method_call.method_name).to eq('hello')
      expect(method_call.receiver).to be_a(Fasterer::MethodCall)
      expect(method_call.receiver.name).to eq('hi')
      expect(method_call.arguments).to be_empty
    end

  end

  describe 'method call with equals operator' do

    let(:file_name) { 'method_call_with_equals.rb' }

    let(:call_element) { ripper.drop(1).first.first[1] }

    xit 'should recognize receiver' do
      # expect(method_call.method_name).to eq('hello')
      # expect(method_call.receiver).to be_a(Fasterer::MethodCall)
      # expect(method_call.receiver.name).to eq('hi')
    end

  end


  # Needed for Hash.fetch. Need to do more reconstruction,
  # before recognizing method calls arguments.
  describe 'method call with a block' do

    let(:file_name) { 'method_call_with_a_block.rb' }

    let(:call_element) { ripper.drop(1).first.last }

    it 'should detect block' do
      expect(method_call.method_name).to eq('fetch')
      expect(method_call.arguments).to be_empty
      expect(method_call.has_block?).to be
      expect(method_call.receiver).to be_a(Fasterer::VariableReference)
    end

  end

  describe 'method call with an argument and a block' do

    let(:file_name) { 'method_call_with_an_argument_and_a_block.rb' }

    let(:call_element) { ripper.drop(1).first.last }

    it 'should detect argument and a block' do
      expect(method_call.method_name).to eq('fetch')
      expect(method_call.arguments.count).to eq(1)
      expect(method_call.arguments.first.type).to eq(:symbol_literal)
      expect(method_call.has_block?).to be
      expect(method_call.receiver).to be_a(Fasterer::VariableReference)
    end

  end

  # method_add_arg
  describe 'method call with an argument' do

    let(:file_name) { 'method_call_with_one_argument.rb' }

    let(:call_element) { ripper.drop(1).first.first }

    it 'should detect argument' do
      expect(method_call.method_name).to eq('fetch')
      expect(method_call.arguments.count).to eq(1)
      expect(method_call.arguments.first.type).to eq(:symbol_literal)
      # expect(method_call.receiver).to be_a(Fasterer::MethodCall)
      # expect(method_call.receiver.name).to eq('hi')
    end

  end

  describe 'method call with an argument without brackets' do

    let(:file_name) { 'method_call_without_brackets.rb' }

    let(:call_element) { ripper.drop(1).first.first }

    it 'should detect argument' do
      expect(method_call.method_name).to eq('fetch')
      expect(method_call.arguments.count).to eq(2)
      expect(method_call.arguments[0].type).to eq(:symbol_literal)
      expect(method_call.arguments[1].type).to eq(:symbol_literal)
      # expect(method_call.receiver).to be_a(Fasterer::MethodCall)
      # expect(method_call.receiver.name).to eq('hi')
    end

  end


  describe 'method call with two arguments' do

    let(:file_name) { 'method_call_with_two_arguments.rb' }

    let(:call_element) { ripper.drop(1).first.last }

    it 'should detect arguments' do
      expect(method_call.method_name).to eq('fetch')
      expect(method_call.arguments.count).to eq(2)
      expect(method_call.arguments[0].type).to eq(:symbol_literal)
      expect(method_call.arguments[1].type).to eq(:symbol_literal)
      expect(method_call.receiver).to be_a(Fasterer::VariableReference)
    end

  end

  describe 'method call with a regex argument' do

    let(:file_name) { 'method_call_with_a_regex_argument.rb' }

    let(:call_element) { ripper.drop(1).first.first }

    it 'should detect regex argument' do
      expect(method_call.method_name).to eq('fetch')
      expect(method_call.arguments.count).to eq(1)
      expect(method_call.arguments[0].type).to eq(:regexp_literal)
    end

  end

  describe 'method call with a integer argument' do

    let(:file_name) { 'method_call_with_a_integer_argument.rb' }

    let(:call_element) { ripper.drop(1).first.first }

    it 'should detect regex argument' do
      expect(method_call.method_name).to eq('flatten')
      expect(method_call.arguments.count).to eq(1)
      expect(method_call.arguments[0].type).to eq(:@int)
      expect(method_call.arguments[0].value).to eq("1")
    end

  end

end
