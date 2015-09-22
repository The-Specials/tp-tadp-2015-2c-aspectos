require 'rspec'
require_relative '../src/origin'
require_relative '../src/with_transformations'
require_relative 'data/mocks_for_transformations'

describe WithTransformations do

  let(:an_object) {AClass.new}
  let(:another_object) {AnotherClass.new}

  a_method = AClass.instance_method :a_public_method
  another_method = AClass.instance_method :another_method
  another_public_method = AnotherClass.instance_method :a_public_method
  a_module_method = AModule.instance_method :a_module_method

  before(:each) do
    AClass.send(:define_method, :a_public_method, proc{ |*args| a_method.bind(self).call *args })
    AClass.send(:define_method, :another_method, proc{ |*args| another_method.bind(self).call *args })
    AnotherClass.send(:define_method, :a_public_method, proc{ |*args| another_public_method.bind(self).call *args })
    AModule.send(:define_method, :a_module_method, proc{ |*args| a_module_method.bind(self).call *args })
  end

  describe '#inject' do
    it do
      a_method.inject({a: 78, c:12})
      expect(an_object.a_public_method 9999, 5).to eql 95
    end

    it do
      a_method.inject({c:8})
      expect(an_object.a_public_method 5, 2).to eql 15
    end
  end

  describe '#redirect_to' do
    it do
      a_method.redirect_to(another_object)
      expect(an_object.a_public_method 'a method').to eql 'Im a method from AnotherMockedClass'
    end

    it do
      a_method.redirect_to(another_object)
      expect{an_object.a_public_method 1, 2, 3}.to raise_error ArgumentError
    end

    it do
      a_method.redirect_to(another_object)
      expect{an_object.a_public_method 1}.to raise_error TypeError
    end
  end

  describe '#instead' do
      it do
        a_method.instead do
          self
        end.call 
        expect(an_object.a_public_method).to eql an_object
      end

      it do
        another_public_method.instead do |x, y|
          x + y
        end
        expect(another_object.a_public_method 2, 3).to eql 5
      end
  end

  describe '#after' do
    it do
      a_method.before{ @aux }
      expect(an_object.a_public_method 10).to eql 32
    end

    it do
      another_public_method.before{ @aux }
      expect(another_object.a_public_method 'an after method').to eql 'Im an after method from AnotherMockedClass'
    end
  end

  describe '#before' do
    it do
      a_method.before{ @aux = 20 }
      expect(an_object.a_public_method 0, 1, 2).to eql 23
    end

    it do
      another_public_method.before{ @aux = 'a before' }
      expect(another_object.a_public_method '', 'the original method').to eql 'Im a before from the original method'
    end
  end

  context 'when a transformation is aplied to methods of a Class origin' do
    it do
      a_method.before{ @aux = 20 }
      expect(an_object.a_public_method 0, 1, 2).to eql 23
      expect(AClass.new.a_public_method 0, 1, 2).to eql 23
    end
  end

  context 'when a transformation is aplied to methods of a Module origin' do
    it do
      a_module_method.before{ @aux = 20 }
      expect(AnotherClass.new.a_module_method 0, 1, 2).to eql 40
      expect(AnotherClass.new.a_module_method 0, 1, 2).to eql 40
    end
  end

  context 'when a transformation is aplied to methods of an instance origin' do
    it 'should only affect that instance' do
      an_instance_method = an_object.origin_method :a_public_method

      an_instance_method.before{ @aux = 20 }
      expect(an_object.a_public_method 0, 1, 2).to eql 23
      expect(AClass.new.a_public_method 0, 1, 2).to eql 3
    end
  end

  describe '#transform' do
    method_list = [a_method, another_method]

    it do
      AClass.transform method_list do redirect_to(AnotherClass.new) end
      expect(an_object.a_public_method 'a method').to eql 'Im a method from AnotherMockedClass'
      expect(an_object.another_method).to eql 'Im from MockModule'
    end

    it do
      AClass.transform method_list do instead { self } end
      expect(an_object.a_public_method).to eql an_object
      expect(an_object.another_method).to eql an_object
    end

    it do
      AClass.transform method_list do before { @aux = 20 } end
      expect(an_object.a_public_method 0, 1, 2).to eql 23
      expect(an_object.another_method).to eql 20
    end

    it do
      an_object.aux = nil
      AClass.transform method_list do after { @aux } end
      expect(an_object.a_public_method 10).to eql 32
      expect(an_object.another_method).to eql 32
    end
  end

end