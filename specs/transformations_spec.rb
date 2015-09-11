require 'rspec'
require_relative '../src/with_transformations'
require_relative 'data/mocks_for_transformations'

describe WithTransformations do

  include WithTransformations

  let(:an_object) {AClass.new}
  let(:another_object) {AnotherClass.new}
  let(:a_method) {AClass.instance_method :a_public_method}
  let(:another_method) {AnotherClass.instance_method :a_public_method}

  a_method_orig = AClass.instance_method :a_public_method
  another_method_orig = AnotherClass.instance_method :a_public_method

  before(:each) do
    AClass.send(:define_method, :a_public_method, proc{ |*args| a_method_orig.bind(self).call *args })
    AnotherClass.send(:define_method, :a_public_method, proc{ |*args| another_method_orig.bind(self).call *args })
  end

  describe '#inject' do

  end

  describe '#redirect_to' do
    it do
      redirect_to(another_object).call a_method
      expect(an_object.a_public_method 'a method').to eql 'Im a method from AnotherMockedClass'
    end

    it do
      redirect_to(another_object).call a_method
      expect{an_object.a_public_method 1, 2, 3}.to raise_error ArgumentError
    end

    it do
      redirect_to(another_object).call a_method
      expect{an_object.a_public_method 1}.to raise_error TypeError
    end
  end

  describe '#instead' do
      it do
        instead do
          self
        end.call a_method
        expect(an_object.a_public_method).to eql an_object
      end

      it do
        instead do |x, y|
          x + y
        end.call another_method
        expect(another_object.a_public_method 2, 3).to eql 5
      end
  end

  describe '#after' do
    it do
      after{ @aux }.call a_method
      expect(an_object.a_public_method 10).to eql 32
    end

    it do
      after{ @aux }.call another_method
      expect(another_object.a_public_method 'an after method').to eql 'Im an after method from AnotherMockedClass'
    end
  end

  describe '#before' do
    it do
      before{ @aux = 20 }.call a_method
      expect(an_object.a_public_method 0, 1, 2).to eql 23
    end

    it do
      before{ @aux = 'a before' }.call another_method
      expect(another_object.a_public_method '', 'the original method').to eql 'Im a before from the original method'
    end
  end

end