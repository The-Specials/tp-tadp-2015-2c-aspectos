require 'rspec'
require_relative '../src/aspects'
require_relative '../src/origin'
require_relative 'data/origin_mocks'
require_relative 'data/mocks_for_conditions'
require_relative 'data/mocks_for_transformations'

describe Aspects do

  include WithConditions
  include WithTransformations

  describe '#on' do

    let(:origen_valido) { ObjectMock.new }
    let(:origen_invalido) { OrigenInvalido.new }
    let(:instance) { ObjectMock.new }
    let(:regex) { RegexMock.new }

    context 'when no arguments are passed' do
      it do
        expect{Aspects.on do end}.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1+)')
      end
    end

    context 'when there are not any valid Origenes' do
      it do
        expect{Aspects.on(origen_invalido) do end}.to raise_error(ArgumentError, 'origen vacio')
      end

      it do
        expect{Aspects.on(origen_invalido, OrigenInvalido.new, OrigenInvalido.new) do end}.to raise_error(ArgumentError, 'origen vacio')
      end
    end

    context 'when there are at least one valid Origen' do
      it do
        expect(Aspects.on(origen_valido) do end).to eq [origen_valido]
      end

      it do
        expect(Aspects.on(origen_valido, origen_invalido) do end).to eq [origen_valido]
      end
    end

    context 'when there are many valid Origenes' do
      it do
        expect(Aspects.on(instance, ClassMock, ModuleMock) do end).to eq [instance, ClassMock, ModuleMock]
      end
    end

    context 'when there are valid and invalid Origenes' do
      it do
        expect(Aspects.on(origen_invalido, instance, OrigenInvalido.new, ModuleMock) do end).to eq [instance, ModuleMock]
      end
    end

    context 'when there are duplicated Origenes' do
      it do
        expect(Aspects.on(origen_valido, ClassMock, instance, instance, ClassMock) do end).to eq [origen_valido, ClassMock, instance]
      end

      it do
        expect(Aspects.on(instance, ModuleMock, regex, ClassMock) do end).to eq [instance, ModuleMock, ClassMock]
      end
    end

  end

  describe '#where' do

    before(:all) do
      Aspects.origins = [MockClass, MockModule, true]
    end

    context 'when no method satisfy all conditions' do
      it do
        expect(Aspects.where(name(/zzzz/))).to eql []
      end

      it do
        expect(Aspects.where(name(//), is_private, is_public)).to eql []
      end

      it do
        expect(Aspects.where(name(//), is_private, has_parameters(16))).to eql []
      end
    end

    context 'when some methods satisfy all conditions' do
      it do
        expect(Aspects.where(name(/^a_public_method/))).to eql [MockClass.instance_method(:a_public_method)]
      end

      it do
        expected = [MockClass.instance_method(:a_public_method),
                    MockClass.instance_method(:a_private_method),
                    MockModule.instance_method(:a_module_method),
                    MockModule.instance_method(:a_private_method)]

        expect(Aspects.where(name(/^a_/))).to eql expected
      end
    end

  end

  describe '#transform' do

    an_object = AClass.new
    another_object = AnotherClass.new
    method_list = [AClass.instance_method(:a_public_method),
                   AClass.instance_method(:another_method)]

    a_public_method = AClass.instance_method :a_public_method
    another_method = AClass.instance_method :another_method

    before(:each) do
      AClass.send(:define_method, :a_public_method, proc{ |*args| a_public_method.bind(self).call *args })
      AClass.send(:define_method, :another_method, proc{ |*args| another_method.bind(self).call *args })
    end

    it do
      Aspects.transform *method_list do redirect_to(another_object) end
      expect(an_object.a_public_method 'a method').to eql 'Im a method from AnotherMockedClass'
      expect(an_object.another_method).to eql 'Im from MockModule'
    end

    it do
      Aspects.transform *method_list do instead { self } end
      expect(an_object.a_public_method).to eql an_object
      expect(an_object.another_method).to eql an_object
    end

    it do
      Aspects.transform *method_list do before { @aux = 20 } end
      expect(an_object.a_public_method 0, 1, 2).to eql 23
      expect(an_object.another_method).to eql 20
    end

    it do
      an_object.aux = nil
      Aspects.transform *method_list do after { @aux } end
      expect(an_object.a_public_method 10).to eql 32
      expect(an_object.another_method).to eql 32
    end
  end

end