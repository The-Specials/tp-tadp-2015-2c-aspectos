require 'rspec'
require 'spec_helper'
require_relative '../src/aspects'

describe 'Origin' do

  class TestClass
    def test_method
    end
  end

  class TestClass2
    def test_method2
    end
  end

  module TestModule
    def test_module
    end
  end

  before(:all) do
    Object.send(:include, Origin)
    Class.send(:include, Origin)
    Regexp.send(:include, Origin)
    Module.send(:include, Origin)
  end

  let(:test_object) { TestClass.new }
  let(:test_object2) { TestClass2.new }
  let(:obj) { Object.new }
  let(:cla) { Class.new }
  let(:reg) { Regexp.new }
  let(:mod) { Module }

  describe '#defined?' do

    it 'An object' do
      expect(obj.defined?).to be true
    end

    it 'A class' do
      expect(cla.defined?).to be true
    end

    it 'A valid regexp' do
      expect(/Class/.defined?).to be true
    end

    it 'A invalid regexp' do
      expect(/NotAClass/.defined?).to be false
    end

    it 'A module' do
      expect(mod.defined?).to be true
    end

  end

  describe '#result' do

    it 'An object should return itself' do
      expect(obj.result).to eq(obj)
    end

    it 'A class shuld return itself' do
      expect(cla.result).to eq(cla)
    end

    it 'A valid regexp should return an array of classes' do
      expect(/Object/.result).to eq([Object, BasicObject, ObjectSpace])
    end

    it 'An invalid regexp should return an empty array' do
      expect(/NotAClass/.result).to eq([])
    end

    it 'A module should return itself' do
      expect(mod.result).to eq(mod)
    end

  end

  describe '#object_methods' do

    it 'An object should return it\'s methods' do
      expect(test_object.object_methods).to eq([:test_method])
    end

    it 'A modified object should return it\'s methods' do
      test_object.singleton_class.send(:define_method, 'test') {}
      expect(test_object.object_methods.sort).to eq([:test_method, :test].sort)
    end

    it 'An object with modules should return it\'s composed methods' do
      TestClass2.send(:include, TestModule)
      expect(test_object2.object_methods.sort).to eq([:test_method2, :test_module].sort)
    end


    it 'A class should return it\'s methods' do
      expect(TestClass.object_methods).to eq([:test_method])
    end

    it 'A class with modules should return it\'s composed methods' do
      TestClass.send(:include, TestModule)
      expect(TestClass.object_methods.sort).to eq([:test_method, :test_module].sort)
    end

    it 'A module should return it\'s methods' do
      expect(TestModule.object_methods).to eq([:test_module])
    end

    it 'A valid regexp should return an array of arrays of modules' do
      expect(/\bTestClass\b/.object_methods).to eq([TestClass.object_methods])
    end

  end

end