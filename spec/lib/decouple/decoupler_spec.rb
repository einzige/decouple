require 'spec_helper'

describe Decouple::Decoupler do
  subject(:decoupler) { Decouple::Decoupler.new(klass) }

  let(:klass) do
    Class.new do
      def action
        proceed_action :argument
      end

      private

      def perform_job(param)
      end
    end
  end

  describe '#run' do
    context 'calling in a correct context' do
      let(:klass) do
        Class.new do
          def action
            decoupler = Decouple::Decoupler.new(self.class) do
              on(:action) { |param| perform_job(param) }
            end
            decoupler.run(self, :argument)
          end

          private

          def perform_job(param)
          end
        end
      end

      let(:klass_instance) { klass.new }

      specify do
        expect(klass_instance).to receive(:perform_job).with(:argument)
        klass_instance.action
      end
    end

    context 'context is invalid' do
      let(:random_context) { 'random_context' }

      specify do
        expect(random_context).not_to receive(:perform_job)
        expect { decoupler.run(random_context) }.to raise_error(ArgumentError, /Running String/)
      end
    end

    context 'calling out of context' do
      before do
        decoupler.on :action do
          perform_job(:param)
        end
      end

      let(:klass_instance) { klass.new }

      specify do
        expect(klass_instance).not_to receive(:perform_job)
        expect { decoupler.run(klass_instance) }.to raise_error /No action to proceed/
      end
    end
  end

  describe '#run_on' do
    context 'registered action' do
      before do
        decoupler.on :action do
          perform_job(:param)
        end
      end

      let(:klass_instance) { klass.new }

      specify do
        expect(klass_instance).to receive(:perform_job).with(:param)
        decoupler.run_on(klass_instance, :action, :param)
      end
    end

    context 'unregistered action' do
      specify do
        expect { decoupler.run_on(:anything, :unregistered_action) }.to raise_error ArgumentError, /No callback/
      end
    end
  end
end
