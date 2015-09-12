require 'rspec'
require_relative '../src/origin'
require_relative 'data/mocks_for_conditions'

describe 'Origen' do

  let(:an_instance) { Object.new }
  let(:a_module) { MockModule }
  let(:a_class) { MockClass }

  describe 'get_origenes' do

    context 'when get_origenes is sended to a concrete Origen' do
      it do
        expect(an_instance.get_origin).to be an_instance
      end

      it do
        expect(a_class.get_origin).to be a_class
      end

      it do
        expect(a_module.get_origin).to be a_module
      end
    end

    context 'when get_origenes is sended to a Regex Origen' do
      it do
        expect(/.*/.get_origin.size).to eq(Object.constants.size)
      end

      it do
        expect(/^O/.get_origin).to include(Object, Origin)
      end

      it do
        expect(/^[C|M|R]/.get_origin).to include(Regexp, Module, Class)
      end

      it do
        expect(/^ZZZZZZ/.get_origin).to be_empty
      end
    end

  end

  describe 'owner' do
    it do
      expect(a_class.origin_methods[0].owner).to be a_class
    end

    it do
      expect(a_module.origin_methods[0].owner).to be a_module
    end

    it do
      expect(an_instance.origin_methods[0].owner).to eql an_instance.singleton_class
    end
  end

  describe 'origin_method_names' do

    it do
      expect(a_class.origin_method_names).to include *a_class.private_instance_methods(true)
      expect(a_class.origin_method_names).to include *a_class.instance_methods(true)
    end

    it do
      expect(a_module.origin_method_names).to include *a_module.private_instance_methods(true)
      expect(a_module.origin_method_names).to include *a_module.private_instance_methods(true)
    end

    it do
      expect(an_instance.origin_method_names).to include *an_instance.singleton_class.private_instance_methods(true)
      expect(an_instance.origin_method_names).to include *an_instance.singleton_class.private_instance_methods(true)
    end

    it do
      def an_instance.an_instance_method
      end

      expect(an_instance.origin_method_names).to include(:an_instance_method)
      expect(an_instance.origin_method_names).to include(:get_origin)
    end

    it do
      def a_class.a_class_method
      end

      expect(a_class.origin_method_names).not_to include(:a_class_method)
    end

    it do
      def a_module.a_class_method
      end

      expect(a_module.origin_method_names).not_to include(:a_class_method)
    end
  end

  describe 'origin_methods' do

    it do
      a_method = a_class.instance_method(:a_public_method)
      expect(a_class.origin_methods).to include a_method
    end

    it do
      a_method = a_module.instance_method(:a_module_method)
      expect(a_module.origin_methods).to include a_method
    end
  end

end