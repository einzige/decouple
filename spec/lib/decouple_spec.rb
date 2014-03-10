require 'spec_helper'

describe Decouple do
  let(:klass) do
    Class.new do
      include Decouple

      def action
        proceed_action :param, :another_param
      end

      private

      def perform_job(param)
      end

      def perform_another_job(another_param)
      end
    end
  end

  before do
    klass.decouple do
      on :action do |param, another_param|
        perform_job param
      end
    end
  end

  before do
    klass.decouple do
      on :action do |param, another_param|
        perform_another_job another_param
      end
    end
  end

  let(:klass_instance) { klass.new }

  it 'calls all registered callbacks on method call' do
    expect(klass_instance).to receive(:perform_job).with(:param)
    expect(klass_instance).to receive(:perform_another_job).with(:another_param)
    klass_instance.action
  end

  context 'registering the same callback twice' do
    specify do
      expect {
        klass.decouple do
          on(:action) {}
          on(:action) {}
        end
      }.to raise_error(ArgumentError, /already callbacked/)
    end
  end

  context 'registering callback on unexisting method' do
    specify do
      expect {
        klass.decouple do
          on(:unexisting_action) {}
        end
      }.to raise_error(ArgumentError, /No such action/)
    end
  end
end
