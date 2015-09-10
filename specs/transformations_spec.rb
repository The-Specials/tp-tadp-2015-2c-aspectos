require 'rspec'
require_relative '../src/with_transformations'
require_relative '../specs/data/methods_mock'

describe WithTransformations do

  include WithTransformations

  let(:an_object) {MockClass.new}
  let(:another_object) {AnotherMockedClass.new}
  let(:a_method) {MockClass.instance_method :a_public_method}
  let(:another_method) {AnotherMockedClass.instance_method :a_public_method}

  a_method_orig = MockClass.new.method :a_public_method
  another_method_orig = AnotherMockedClass.new.method :a_public_method

  before(:each) do
    MockClass.send(:define_method, :a_public_method, &a_method_orig)
    AnotherMockedClass.send(:define_method, :a_public_method, &another_method_orig)
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

  end

  describe '#before' do
    it do
      before do
        @aux = 99
        puts self
      end.call a_method
      an_object.a_public_method 0, 1, 2
      #expect(an_object.a_public_method 0, 1, 2).to eql an_object
      #expect(an_object.aux).to eql 99
      puts an_object
    end

    # it do
    #   before do
    #     puts self == another_method
    #   end.call another_method
    #   expect(another_object.a_public_method '', ' the original method').to eql 'Im a before from AnotherMockedClass'
    # end
  end

end