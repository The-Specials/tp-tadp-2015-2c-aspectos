require 'rspec'
require_relative '../src/origen'

describe 'Origen' do

  let(:an_object) { Object.new }
  let(:a_module) { Module.new }
  let(:a_class) { Class.new }

  describe 'get_origenes' do

    context 'when get_origenes is sended to a concrete Origen' do
      it do
        expect(an_object.get_origenes).to be an_object
      end

      it do
        expect(a_class.get_origenes).to be a_class
      end

      it do
        expect(a_module.get_origenes).to be a_module
      end
    end

    context 'when get_origenes is sended to a Regex Origen' do
      it do
        expect(/.*/.get_origenes.size).to eq(Object.constants.size)
      end

      it do
        expect(/^O/.get_origenes).to include(Object, Origen)
      end

      it do
        expect(/^[C|M|R]/.get_origenes).to include(Regexp, Module, Class)
      end

      it do
        expect(/^ZZZZZZ/.get_origenes).to be_empty
      end
    end

  end
end