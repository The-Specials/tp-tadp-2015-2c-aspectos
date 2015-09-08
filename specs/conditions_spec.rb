require 'rspec'
require_relative '../src/with_conditions'
require_relative '../specs/data/methods_mock'

describe WithConditions do

  include WithConditions

  let(:a_method) { MockClass.instance_method(:a_public_method) }
  let(:a_public_method) { MockClass.instance_method(:a_public_method) }
  let(:a_private_method) { MockClass.instance_method(:a_private_method) }

  describe '#name' do
    it do
      expect(name(/^a_public_method$/).call(a_method)).to be_truthy
    end

    it do
      expect(name(/foo/).call(a_method)).to be_falsey
    end
  end

  describe '#is_private/is_public' do
    it do
      expect(is_private.call(a_public_method)).to be_falsey
    end

    it do
      expect(is_private.call(a_private_method)).to be_truthy
    end

    it do
      expect(is_public.call(a_private_method)).to be_falsey
    end

    it do
      expect(is_public.call(a_public_method)).to be_truthy
    end
  end

  describe '#has_parameters' do
    it do
      expect(has_parameters(3).call(a_public_method)).to be_truthy
    end

    it do
      expect(has_parameters(2).call(a_public_method)).to be_falsey
    end

    it do
      expect(has_parameters(2, optional).call(a_public_method)).to be_truthy
    end

    it do
      expect(has_parameters(1, mandatory).call(a_public_method)).to be_truthy
    end

    it do
      expect(has_parameters(1, optional).call(a_public_method)).to be_falsey
    end

    it do
      expect(has_parameters(2, mandatory).call(a_public_method)).to be_falsey
    end

  end

  describe '#neg' do
    it do
      expect(neg(name(/^a_public_method$/)).call(a_public_method)).to be_falsey
    end

    it do
      expect(neg(name(/foo/)).call(a_public_method)).to be_truthy
    end

    it do
      expect(neg(name(/foo/), name(/^a$/)).call(a_public_method)).to be_truthy
    end

    it do
      expect(neg(is_private, has_parameters(2)).call(a_public_method)).to be_truthy
    end

    it do
      expect(neg(is_private, is_public).call(a_public_method)).to be_falsey
    end
  end

end