require 'rspec'
require_relative '../src/aspects'
require_relative 'data/origen_mocks'

describe Aspects do

  let(:origen_valido) { ObjectMock.new }
  let(:origen_invalido) { OrigenInvalido.new }
  let(:instance) { ObjectMock.new }
  let(:regex) { RegexMock.new }

  describe '#on' do

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
end