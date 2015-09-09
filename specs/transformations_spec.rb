require 'rspec'
require_relative '../src/with_transformations'
require_relative '../specs/data/methods_mock'

describe WithTransformations do

  include WithTransformations

  let(:an_object) {MockClass.new}
  let(:another_object) {AnotherMockedClass.new}
  let(:a_method) {an_object.method :a_public_method}

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

  describe '#after' do

  end

  describe '#before' do

  end

  describe '#instead' do

  end
end

