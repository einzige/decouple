require 'decouple/decoupler'

module Decouple
  VERSION = '0.0.1'

  # @param base [Class]
  def self.included(base)
    base.extend(Decouple::ClassMethods)
  end

  # Runs callbacks for calling context (decoupled method is a context)
  # @param arguments [Array]
  def proceed_action(*arguments)
    self.class.decouplings.each { |decoupler| decoupler.run(self, *arguments) }
  end

  # Runs callbacks for a specific method
  # @param action [String] Method name to proceed with
  # @param arguments [Array]
  def proceed_with(action, *arguments)
    self.class.decouplings.each do |decoupler|
      decoupler.run_on(self, action, *arguments)
    end
  end

  module ClassMethods

    # Attaches callbacks
    # @yield
    def decouple(&block)
      decouplings << Decouple::Decoupler.new(self, &block)
    end

    # Returns a list of attached callback containers
    # @return [Array<Decouple::Decoupler>]
    def decouplings
      @decouplings ||= []
    end
  end
end
