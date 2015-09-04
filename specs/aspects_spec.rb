require 'rspec'
require_relative '../src/aspects'
require_relative 'data/origen_mocks'

describe Aspects do

  let(:origenValido) { Object_Mock.new }
  let(:origenInvalido) { OrigenInvalido.new }
  let(:instance) { Object_Mock.new }
  let(:regex) { Regex_Mock.new }

  describe '#on' do

    context 'when no arguments are passed' do
      it do
        expect{Aspects.on do end}.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1+)')
      end
    end

    context 'when there are not any valid Origenes' do
      it do
        expect{Aspects.on(origenInvalido) do end}.to raise_error(ArgumentError, 'origen vacio')
      end

      it do
        expect{Aspects.on(origenInvalido, OrigenInvalido.new, OrigenInvalido.new) do end}.to raise_error(ArgumentError, 'origen vacio')
      end
    end

    context 'when there are at least one valid Origen' do
      it do
        expect(Aspects.on(origenValido) do end).to eq [origenValido]
      end

      it do
        expect(Aspects.on(origenValido, origenInvalido) do end).to eq [origenValido]
      end
    end

    context 'when there are many valid Origenes' do
      it do
        expect(Aspects.on(instance, Class_Mock, Module_Mock) do end).to eq [instance, Class_Mock, Module_Mock]
      end
    end

    context 'when there are valid and invalid Origenes' do
      it do
        expect(Aspects.on(origenInvalido, instance, OrigenInvalido.new, Module_Mock) do end).to eq [instance, Module_Mock]
      end
    end

    context 'when there are duplicated Origenes' do
      it do
        expect(Aspects.on(origenValido, Class_Mock, instance, instance, Class_Mock) do end).to eq [origenValido, Class_Mock, instance]
      end

      it do
        expect(Aspects.on(instance, Module_Mock, regex, Class_Mock) do end).to eq [instance, Module_Mock, Class_Mock]
      end
    end

  end
end