require 'spec_helper'

describe Fasterer::MethodDefinition do

  let(:def_element) do
    ripper = Fasterer::Parser.parse(File.read(RSpec.root.join('support', 'method_definition', file_name)))
    ripper.last.first
  end

  let(:method_definition) do
    Fasterer::MethodDefinition.new(def_element)
  end

  describe 'method with no arguments' do

    let(:file_name) { 'simple_method.rb' }

    it 'should not detect block' do
      expect(method_definition.method_name).to eq('hello')
      expect(method_definition.has_block?).to eq(false)
    end

  end

  describe 'method with no arguments and omitted parenthesis' do

    let(:file_name) { 'simple_method_omitted_parenthesis.rb' }

    it 'should not detect block' do
      expect(method_definition.method_name).to eq('hello')
      expect(method_definition.has_block?).to eq(false)
    end

  end

  describe 'method with one argument' do

    let(:file_name) { 'simple_method_with_argument.rb' }

    it 'should not detect block' do
      expect(method_definition.method_name).to eq('hello')
      expect(method_definition.has_block?).to eq(false)
    end

  end

  describe 'method with a block' do

    let(:file_name) { 'method_with_block.rb' }

    it 'should detect block' do
      expect(method_definition.method_name).to eq('hello')
      expect(method_definition.has_block?).to eq(true)
      expect(method_definition.block_argument_name).to eq('block')
    end

  end

  describe 'method with an argument and a block' do

    let(:file_name) { 'method_with_argument_and_block.rb' }

    it 'should detect block' do
      expect(method_definition.method_name).to eq('hello')
      expect(method_definition.has_block?).to eq(true)
      expect(method_definition.block_argument_name).to eq('block')
    end

  end

  describe 'method with an splat argument and a block' do

    let(:file_name) { 'method_with_splat_and_block.rb' }

    it 'should detect block' do
      expect(method_definition.method_name).to eq('hello')
      expect(method_definition.has_block?).to eq(true)
      expect(method_definition.block_argument_name).to eq('block')
    end

  end

  describe 'method with an default argument' do

    let(:file_name) { 'method_with_default_argument.rb' }

    it 'should not detect block' do
      expect(method_definition.method_name).to eq('hello')
      expect(method_definition.has_block?).to eq(false)
    end

  end




  # let(:def_element_with_block) do
  #   ripper = Fasterer::Parser.parse(File.read(RSpec.root.join('support', 'method_definition', 'method_with_block.rb')))
  #   ripper.last.first
  # end

  # xit 'should detect a block' do
  #   method_definition = Fasterer::MethodDefinition.new(def_element_with_block)
  #   expect(method_definition.method_name).to eq('hello')
  #   expect(method_definition.has_block?).to eq(true)
  # end

  # let(:def_element_with_default_argument) do
  #   ripper = Fasterer::Parser.parse(File.read(RSpec.root.join('support', 'method_definition', 'method_with_default_argument.rb')))
  #   ripper.last.first
  # end

  # xit 'should detect one argument with predefined value' do
  #   method_definition = Fasterer::MethodDefinition.new(def_element_with_default_argument)
  #   expect(method_definition.method_name).to eq('hello')
  #   expect(method_definition.argument_names).to eq(['name'])
  #   expect(method_definition.has_block?).to eq(false)
  # end

  # let(:def_element_with_splat) do
  #   ripper = Fasterer::Parser.parse(File.read(RSpec.root.join('support', 'method_definition', 'method_with_splat.rb')))
  #   ripper.last.first
  # end

  # xit 'should detect two arguments and a block' do
  #   method_definition = Fasterer::MethodDefinition.new(def_element_with_splat)
  #   expect(method_definition.method_name).to eq('hello')

  #   binding.pry
  #   expect(method_definition.argument_names).to eq(['names'])
  #   expect(method_definition.has_block?).to eq(false)
  # end
end
